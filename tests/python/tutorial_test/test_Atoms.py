'''
Unit test for the tutorial Manipulating Atoms in Python
http://wiki.opencog.org/w/Getting_Started_with_Atoms_and_the_Scheme_Shell

'''
import unittest
from opencog.atomspace import AtomSpace, types,TruthValue,Atom
from opencog.atomspace import types
from opencog.scheme_wrapper import scheme_eval, scheme_eval_h
from opencog.utilities import initialize_opencog
from opencog.type_constructors import *
from opencog.bindlink import satisfying_set
# creating the class that controll all method that we test
class MyTestCase(unittest.TestCase):
    def setUp(self):
        # self.atsp = scheme_eval_as('(cog-atomspace)')
        self.atsp = AtomSpace() #creating atomspace
        self.TV = TruthValue()
        self.test_dog=self.atsp.add_node(types.ConceptNode,"Dog",self.TV)
        self.test_cat=self.atsp.add_node(types.ConceptNode,"Cat",self.TV)
        self.test_animal=self.atsp.add_node(types.ConceptNode,"Animal",self.TV)
        self.test_color=self.atsp.add_node(types.ConceptNode,"color",self.TV)
        initialize_opencog(self.atsp)
    def TearDown(self):
	del self.atsp
    def test_add_node(self):
        #test whether the node is created or not
        self.test_cat_value =scheme_eval_h(self.atsp, "(ConceptNode \"Cat\")")
        self.assertEqual(self.test_cat_value,self.test_cat)
    def test_add_link(self):
        #test whether the link is created between the node
       self.cat_animal=self.atsp.add_link(types.InheritanceLink,[self.test_cat,self.test_animal])
       
       self.assertEqual(InheritanceLink(self.test_cat,self.test_animal),self.cat_animal)
    def test_remove_node(self):
        #test whether the node that is crated is removed or not
       self.assertEqual(True,self.atsp.remove(self.test_cat))
    def test_pattern_match(self):
        #test pattern maching between difetent types of nodes
         
        self.scheme_animals = \
        '''
        (InheritanceLink (ConceptNode "Red") (ConceptNode "color"))
        (InheritanceLink (ConceptNode "Green") (ConceptNode "color"))
        (InheritanceLink (ConceptNode "Blue") (ConceptNode "color"))
        (InheritanceLink (ConceptNode "Spaceship") (ConceptNode "machine"))
        '''
        # create amodule or function in scheme 
        self.scheme_query = \
        '''
        (define find-colors
        (BindLink
            ;; The variable to be bound
            (VariableNode "$xcol")

            ;; The pattern to be searched for
            (InheritanceLink
            (VariableNode "$xcol")
            (ConceptNode "color")
            )
            ;; The value to be returned.
            (VariableNode "$xcol")
        )
        )
        '''
        #use scheme module
        scheme_eval(self.atsp, "(use-modules (opencog))") 
        scheme_eval(self.atsp, "(use-modules (opencog query))")
        scheme_eval_h(self.atsp, self.scheme_animals)
        scheme_eval_h(self.atsp, self.scheme_query)
        self.result = scheme_eval_h(self.atsp, '(cog-bind find-colors)')   
        self.varlink = TypedVariableLink(VariableNode("$xcol"), TypeNode("ConceptNode"))
        self.pattern = InheritanceLink(VariableNode("$xcol"), self.test_color)
        self.colornodes = SatisfactionLink(self.varlink, self.pattern)
        self.assertEqual(self.result,satisfying_set(self.atsp, self.colornodes))

if __name__ == '__main__':
    unittest.main()
