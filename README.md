# RLModules
RLModules is a layout system created on top of `UICollectionView`, for building vertical scrolling content views.

## Layout Modules
Layout modules, subclassed from `RLLayoutModule`, receive information from data sources and notify delegates of events. Concrete implementations provide layout implementations, determining the positioning of each item.

## Compound Modules
Compound modules, subclasses from `RLCompoundModule`, build modules out of other modules. This can be easily used to build a header view or see all button for a section - just chain a `RLTableModule` before or after another module.

## Module Controller
The class `RLModuleController` can be used to implement a controller object for a module, instead of using your view controller subclass as the data source and delegate for all of your modules.

## Collection View
RLModules is built on top of `UICollectionView`. This mostly shows through in two places:

* Your cell class will subclass `UICollectionViewCell`.
* You'll dequeue cell classes with the collection view instance and an index path. However, you should use module indexes for retrieving data - index paths are not reliable for data indexing, since modules can be nested inside modules.

## Documentation
RLModules is fully documented with [appledoc](http://gentlebytes.com/appledoc/), which can be easily installed:

    brew install appledoc

Once `appledoc` is installed, use the scripts in the `Documentation` directory to generate documentation.