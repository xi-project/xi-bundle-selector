# Selector functionality for Symfony2

Selector bundle provides a handy selector UI compoment to use with a Symfony 2 project.


## Dependencies

none

## Installing

### deps -file
```
[XiSelectorBundle]
    git=http://github.com/xi-project/xi-bundle-selector.git
    target=/bundles/Xi/Bundle/SelectorBundle
```

### autoload.php file
```php
<?php
'Xi\\Bundle'       => __DIR__.'/../vendor/bundles',
?>
```

### appKernel.php -file
```php
<?php
            new Xi\Bundle\SelectorBundle\XiSelectorBundle(),
 ?>
```

## Usage:

You need to initialize selector in your main script file.

```coffeescript    
    options = {
        mainElement:            '.tag_item_selector',
        autoCompleteElement:    '.item_field', 
        containerElement:       '.items ul', 
        source:                 'URL TO SEARCH ACTION',     
        saveUrl:                'URL TO ADD ACTION',    
        selected:               selected,
        canAddNew:              true        # CAN YOU ADD NEW ITEM, OR JUST SELECT WHAT YOU HAVE SEARCHED.
        minLength:              3           # MIN TEXT LENGTH BEFORE SEARCH KICKS IN
    }
    yourSelector = new App.Selector(options)
```