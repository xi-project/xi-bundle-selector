<?php

namespace Xi\Bundle\SelectorBundle\Twig\Extensions;

use \Twig_Environment,
    Symfony\Component\Form\FormView;

class Selector extends \Twig_Extension
{
    /**
     * @var Twig_Environment
     */
    protected $twig;
    
    /**
     * @param Twig_Environment $twig 
     */
    public function __construct(Twig_Environment $twig)
    {
        $this->twig = $twig; 
    }
    
    public function getFunctions()
    {
        return array(
            'xi_selector' => new \Twig_Function_Method(
                $this, 'itemSelector', array('is_safe' => array('html') )
            ),
            'xi_selector_items' => new \Twig_Function_Method(
                $this, 'items', array('is_safe' => array('html') )
            ),
        );
    }
    
    public function itemSelector($items)
    {
        return $this->twig->render('XiTagBundle:Form:tag-selector.html.twig',
            array('items' => $items)
        );
    }
    
    public function items($items)
    {
        return $this->twig->render('XiSelectorBundle:Form:items.html.twig',
            array('items' => $items)
        );
    }
    
    public function getName()
    {
        return 'selector_extension';
    }
}