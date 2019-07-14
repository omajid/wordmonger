# wordmonger

This is a [GNU Emacs](https://www.gnu.org/software/emacs/) package
that highlights problematic words based on your technical and
documentation standards.

When enabled, it will check the contents of local files and highlight
words that you have specified and show suggestions about the correct
replacement.

## Installing

Until this package lands in a package repository, use Emacs's package
manager to install this package:

In a terminal:

``` bash
git clone https://github.com/omajid/wordmonger
```

In Emacs:

``` emacs-lisp
(add-to-list 'load-path "/path/to/where/you/cloned/wordmonger")
(require 'wordmonger)
(add-to-list 'wordmonger-word-alist '("linux" "GNU/Linux"))
(add-to-list 'wordmonger-word-alist '("os" "Operating System"))
```

If you are using `use-package`:

``` emacs-lisp
(use-package wordmonger
  :load-path "/path/to/where/you/cloned/wordmonger/"
  :demand
  :config
  (add-to-list 'wordmonger-word-alist '("linux" "GNU/Linux"))
  (add-to-list 'wordmonger-word-alist '("os" "Operating System")))
```

## Using

This package provides a useful number of features for checking words
in your technical documents:

- `M-x wordmonger-mode` will enable the minor-mode, checking the
  current buffer for the words you have flagged.

## Authors

* **Omair Majid** - *Initial work* - [omajid](https://github.com/omajid)

See also the list of
[contributors](https://github.com/omajid/wordmonger/contributors) who
participated in this project.

## License

Copyright © 2019 Omair Majid <omair.majid@gmail.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or (at
your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
