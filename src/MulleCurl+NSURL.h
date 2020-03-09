//
//  NSURL+MulleCurl.h
//  MulleWeb
//
//  Created by Nat! on 09.03.20.
//
//  Copyright (c) 2020 Nat! - Mulle kybernetiK
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
#import "import.h"


@interface MulleCurl( NSURL)

+ (NSData *) dataWithContentsOfURL:(NSURL *) url;
+ (id) propertyListWithJSONContentsOfURL:(NSURL *) url;

- (NSData *) dataWithContentsOfURL:(NSURL *) url;

//
// If posting Data make sure that the Content-Type is set correctly.
// the data is send "As Is".
//
// https://stackoverflow.com/questions/4007969/application-x-www-form-urlencoded-or-multipart-form-data
// https://dev.to/sidthesloth92/understanding-html-form-encoding-url-encoded-and-multipart-forms-3lpa

- (NSData *) dataWithContentsOfURL:(NSURL *) url
                     byPostingData:(NSData *) data;

//
// You can not just get NSData but you can also plug in a parser like
// f.e. MulleJSMNParser and translate JSON content directly into whatever
// it is (usually a NSDictionary *) in the JSON case. Since the parsing
// is done incremental, this should have less latency then doing
// -dataWithContentsOfURLWithString: and then doing the parse afterwards (for
// large contents)
// -setParser: beforehand.
//
- (id) parseContentsOfURL:(NSURL *) url;
- (id) parseContentsOfURL:(NSURL *) url
            byPostingData:(NSData *) data;

@end