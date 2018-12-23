﻿/*
* Compression utility header
* 
* Copyright:
* (C) 2014 Jack Lloyd
* (C) 2015 Etienne Cimon
*
* License:
* Botan is released under the Simplified BSD License (see LICENSE.md)
*/

module botan.compression.compress_utils;

import memutils.hashmap;
import botan.utils.mem_ops;
import botan.compression.compress;
import memutils.unique;

/*
* Allocation Size Tracking Helper for Zlib/Bzlib/LZMA
*/
class CompressionAllocInfo
{
public:
    extern(C) static void* malloc(T)(void* self, T n, T size) nothrow
    {
        return (cast(CompressionAllocInfo)self).doMalloc(n, size);
    }
    
	extern(C) static void free(void* self, void* ptr) nothrow
    {
        (cast(CompressionAllocInfo)self).doFree(ptr);
    }
    
private:
    void* doMalloc(size_t n, size_t size) nothrow
    {
        import core.stdc.stdlib : malloc;
        const size_t total_sz = n * size;
        
        void* ptr = malloc(total_sz);
        try m_current_allocs[ptr] = total_sz;
		catch(Exception e) assert(false, e.msg);
        return ptr;
    }
    void doFree(void* ptr) nothrow
    {
        if (ptr)
        {
            import core.stdc.stdlib : free;
			size_t* sz;
			try sz = ptr in m_current_allocs;
			catch (Exception e) assert(false, e.msg);
            if (sz is null)
                assert(false, "CompressionAllocInfo.free got pointer not allocated by us");
            
            clearMem(ptr, *sz);
            free(ptr);
            try m_current_allocs.remove(ptr);
			catch (Exception e) assert(false, e.msg);
        }
    }
    
    HashMap!(void*, size_t) m_current_allocs;
}

/**
* Wrapper for Zlib/Bzlib/LZMA stream types
*/
abstract class ZlibStyleStream(Stream, ByteType) : CompressionStream
{
public:
    override void nextIn(ubyte* b, size_t len)
    {
        m_stream.next_in = cast(ByteType*)(b);
        m_stream.avail_in = cast(uint)len;
    }
    
    override void nextOut(ubyte* b, size_t len)
    {
        m_stream.next_out = cast(ByteType*)(b);
        m_stream.avail_out = cast(uint)len;
    }
    
    override size_t availIn() const { return m_stream.avail_in; }
    
    override size_t availOut() const { return m_stream.avail_out; }
    
    this()
    {
        clearMem(&m_stream, 1);
        m_allocs = new CompressionAllocInfo;
    }
    
    ~this()
    {
        clearMem(&m_stream, 1);
        m_allocs.free();
    }
    
protected:
    alias stream_t = Stream;
    
    stream_t* streamp() { return &m_stream; }
    
    CompressionAllocInfo alloc() { return m_allocs.get(); }
private:
    stream_t m_stream;
    Unique!CompressionAllocInfo m_allocs;
}