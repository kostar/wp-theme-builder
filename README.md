# WordPress Theme builder
This is shell script for initialize WordPress theme based on Underscores project
with prepared Gulp config

#Install

clone project to local

```
git clone git@github.com:reatlat/wp-theme-builder.git
```

##First start

Run builder script

```
./run-builder.sh
```

You will see this menu:
```
  NOTE:
  [1] - [INIT]  - Initial project.
  [2] - [DEV]   - Run gulp on dev mode.
  [3] - [BUILD] - Make current build and compress to *.zip file.
  [0] - [Exit]  - say goodbye =)
```

###Init theme
choose option `[1] - [INIT]  - Initial project.`
and confirm `YES`

answear to next questions:
```
Theme Name:  My New Theme
Theme Slug:  my-new-theme
Author:      Amazing Alex
Author URL:  http://example.com/
Description: This theme was builded with WP-Theme-builder
Theme Tags:  any, your, tags, like, this
```

script create next structure of project:
```
.
├── build
│   ! - directory for preparing theme before compress to zip
├── dev
│   ! - work directory for dev task
├── include
│   ! - directory for required files
├── release
│   ! - directory for store compressed theme.zip
├── source
│   ! - directory for store source files
└── temp
    ! - store temporary files
```

##License
The `include/_s` directory and they contents are Copyright by Automattic and
licensed under GNU General Public License v2 or later.

All other directories and files are MIT licensed unless otherwise specified.
Feel free to use the files as you please. If you do use them, a link back
would be appreciated, but is not required.

##MIT License
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

Copyright © 2017 by [Alex Zappa a.k.a. re[at]lat](https://github.com/reatlat)
