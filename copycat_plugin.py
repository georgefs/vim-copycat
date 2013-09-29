#! /usr/bin/env python
# -*- coding: utf-8 -*-
#
# Copyright © 2013 george 
#
# Distributed under terms of the MIT license.
__all__ = ['copy', 'paste', 'list', 'delete']

import vim
import re
import copycat

# ----------------------------------------------------
# simple python with vim contact interface
# ----------------------------------------------------

def get_from_vim(name):
    name = name.strip()
    if not name:
        return name

    return vim.eval(name)

def set_to_vim(name, value):
    if not isinstance(name, basestring):
        return False

    if isinstance(value, basestring):
        value = re.sub(r'([\"\\])', r'\\\1', value)
        vim.command('let {}=\"{}\"'.format(name, value))
        return True
    return False
    
def vim_command(func):
    def deco(result=None, *args, **kwargs):
        result_reg = result
        result = func(*args, **kwargs)
        if result_reg:
            set_to_vim(result_reg, result)
        
    return deco
    

# ----------------------------------------------------
# copycat vim command
# ----------------------------------------------------

@vim_command
def copy(value, name=None):
    name = get_from_vim(name)
    value = get_from_vim(value)

    copycat.copy(name=name, value=value)

@vim_command
def paste(name=None):
    name = get_from_vim(name)

    return copycat.paste(name)

@vim_command
def list():
    copycat.view()

@vim_command
def remove(name):
    name = get_from_vim(value)
    copycat.delete(name)
