/*
   The MIT License (MIT)

   Copyright (c) 2011 - 2013, Philipp Heise and Sebastian Klose
   Copyright (c) 2016, BMW Car IT GmbH, Philipp Heise (philipp.heise@bmw.de)

   Permission is hereby granted, free of charge, to any person obtaining a copy
   of this software and associated documentation files (the "Software"), to deal
   in the Software without restriction, including without limitation the rights
   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included in
   all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
   THE SOFTWARE.
*/
const sampler_t SAMPLER_NN = CLK_NORMALIZED_COORDS_FALSE | CLK_ADDRESS_CLAMP_TO_EDGE | CLK_FILTER_NEAREST;

__kernel void pyrdown( __write_only image2d_t out,  __read_only image2d_t in )
{
    const int gx = get_global_id( 0 );
    const int gy = get_global_id( 1 );
    const int width = get_image_width( in );
    const int height = get_image_height( in );
    const int dstwidth = get_image_width( out );
    const int dstheight = get_image_height( out );
    int2 coord;

    if( gx >= dstwidth || gy >= dstheight )
        return;

    coord.x = gx * 2;
    coord.y = gy * 2;

    float4 val = 0.25f * read_imagef( in, SAMPLER_NN, coord );
    val += 0.25f * read_imagef( in, SAMPLER_NN, coord + ( int2 ) ( 1, 0 ) );
    val += 0.25f * read_imagef( in, SAMPLER_NN, coord + ( int2 ) ( 0, 1 ) );
    val += 0.25f * read_imagef( in, SAMPLER_NN, coord + ( int2 ) ( 1, 1 ) );

    write_imagef( out, ( int2 )( gx, gy ), val );
}
