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