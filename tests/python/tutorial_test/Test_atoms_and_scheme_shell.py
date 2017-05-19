import unittest
from opencog.atomspace import AtomSpace, types,TruthValue,Atom
from opencog.atomspace import types
from opencog.scheme_wrapper import scheme_eval, scheme_eval_h
from opencog.utilities import initialize_opencog
from opencog.type_constructors import *
#from opencog.atomspace import AtomType


'''
Unit test for the tutorial Getting Started with Atoms and the Scheme Shell 
  http://wiki.opencog.org/w/Getting_Started_with_Atoms_and_the_Scheme_Shell

'''


class Test_Atoms_and_Scheme_shell(unittest.TestCase):



  def setUp(self):
    #creating atomspace
    self.atsp = AtomSpace()
    self.TV = TruthValue()
    initialize_opencog(self.atsp)
  def tearDown(self):
    del self.atsp
    

  def test_create_node(self): #params as (self,type) , to test each and every kind of Atoms
    #creating a node 
    self.node_hello = self.atsp.add_node(types.ConceptNode,"HelloWorld")
    #testing if node is created 
    self.test_node_hello =scheme_eval_h(self.atsp, "(ConceptNode \"HelloWorld\")")
    self.assertEqual(self.test_node_hello,self.node_hello)
    self.assertIsInstance(node,Atom)


  def test_create_links(self):
    #creating nodes
    self.fox = self.atsp.add_node(types.ConceptNode,"Fox")
    self.animal = self.atsp.add_node(types.ConceptNode,"Animal")
    #creating link between nodes
    self.inheritance_link = self.atsp.add_link(types.InheritanceLink,[fox,animal])

    #testing if link is created
    self.test_inheritance_link=self.atsp.add_link(types.InheritanceLink,[self.fox,self.animal])

    self.assertEqual(InheritanceLink(self.fox,self.animal),self.test_inheritance_link)

    self.assertIsInstance(inheritance_link,Atom) # In a sense that links are atoms themselves.



  
if __name__ == '__main__':
    unittest.main()
