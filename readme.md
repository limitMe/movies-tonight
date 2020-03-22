
## What is this?

Movies Tonight shows what movies you can watch inside Australia

It is actually a one day quest when I was interviewed with one famous tech company inside Australia during Aug, 2017. I was asked not to make it open source but I think it's fine to do so in 2020.

## How to Run

Download zip or clone this repo. `cd` to the working folder and run `carthage update` if needed. This application is developed in Xcode 8.3.3 with Swift 3.1.

![Preview](https://j.gifs.com/y80Ggn.gif)

Github does not support such big gif, visit https://j.gifs.com/y80Ggn.gif instead.

## Features

- Pull to refresh, drag to load more.
- No third-party framework in Views or Controllers.
- Details of the movie is provided by an API written by myself with ASP.Net Core, see https://github.com/limitMe/MoviesTonightServer

## Cons

- Too many codes in Controllers due to take some responsiblities of Views. 
- Some UI colors and designs are not suitable with other parts.
- No animation, and some UIs are not "natural" when using in slow network conditions.
- Some pictures are not clear enough.
