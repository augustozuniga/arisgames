#ifndef __READER_H__
#define __READER_H__

/*
 *  Reader.h
 *  zxing
 *
 *  Created by Christian Brunschen on 13/05/2008.
 *  Copyright 2008 ZXing authors All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <map>
#include "common/Counted.h"
#include "Result.h"
#include "MonochromeBitmapSource.h"

using namespace std;

class Reader {
public:
  virtual Ref<Result> decode(Ref<MonochromeBitmapSource> image) = 0;
  virtual ~Reader();
};

#endif // __READER_H__
