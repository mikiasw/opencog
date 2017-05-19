//Unit test for the tutorial Manipulating Atoms in C++
//http://wiki.opencog.org/w/Manipulating_Atoms_in_C%2B%2B

#include <cxxtest/TestSuite.h>
#include <iostream>
#include <opencog/atoms/base/Atom.h>
#include <opencog/atomspace/AtomSpace.h>
#include <opencog/truthvalue/TruthValue.h>
#include <opencog/truthvalue/AttentionValue.h>
#include <opencog/truthvalue/SimpleTruthValue.h>
#include <opencog/query/BindLinkAPI.h>
#include <string>



using namespace opencog;
using namespace std;


class MyTestSute1 : public CxxTest::TestSuite
{


public:
		AtomSpace as ;


	// public :
	// 	void setUp(){}

	


	public:
			void test_making_atoms(void)
		{
						
			Handle h = as.add_node(CONCEPT_NODE, "Cat");
			TS_ASSERT_EQUALS(h,as.get_atom(h));
			TS_ASSERT(h == as.get_atom(h));
		}


	public: 
			void test_create_nested_atomSpace(void)
		{
			
			AtomSpace child_as(&as);
			Handle atom_in_child_as = child_as.add_node(CONCEPT_NODE, "Puma");
			
			TS_ASSERT(atom_in_child_as = child_as.get_atom(atom_in_child_as)); // checks if the atom exits in the child atomspace, assertion must be true
			TS_ASSERT_DIFFERS(atom_in_child_as , as.get_atom(atom_in_child_as)); // checks that the atom in child atomspace does not exits in the parent as
			
			
			cout << "Parent AtomSpace: " << endl << as
				 << "Child AtomSpace: " << endl << child_as;
		}

	
	public :	void test_pattern_matcher(void){
	
		Handle color = as.add_node(CONCEPT_NODE, "Color");
		Handle primarycolor = as.add_node(CONCEPT_NODE, "PrimaryColor");
		Handle c1 = as.add_node(CONCEPT_NODE, "100");
		Handle c2 = as.add_node(CONCEPT_NODE, "010");
		Handle c3 = as.add_node(CONCEPT_NODE, "001");

		HandleSeq hseq = {c1, color};
		as.add_link(INHERITANCE_LINK, hseq);

		hseq[0] = c2;
		as.add_link(INHERITANCE_LINK, hseq);

		hseq[0] = c3;
		as.add_link(INHERITANCE_LINK, hseq);



		Handle h1, h2;
			h1 = as.add_node(VARIABLE_NODE, "$x");
			h2 = as.add_node(TYPE_NODE, "ConceptNode");
			hseq[0] = h1;
			hseq[1] = h2;
			Handle TypedVariableLink = as.add_link(TYPED_VARIABLE_LINK, hseq);
	
			h2 = as.add_node(CONCEPT_NODE, "Color");
			hseq[1] = h2;
			Handle findpattern = as.add_link(INHERITANCE_LINK, hseq);

			hseq[0] = TypedVariableLink;
			hseq[1] = findpattern;
			Handle SatisfactionLink = as.add_link(SATISFACTION_LINK, hseq);

		//Run the PM to get the set of atoms that satisfy the pattern
			Handle colornodes = satisfying_set(&as, SatisfactionLink); 

			//Print out the query result
			cout << "Colors: " << endl << colornodes->toString() << endl;
			

			
			
			//TS_ASSERT_EQUALS(colornodes->toString(),query_result);

		h2 = as.add_node(CONCEPT_NODE, "PrimaryColor");
			hseq[0] = h1;
			hseq[1] = h2;
			Handle writepattern = as.add_link(INHERITANCE_LINK, hseq);

			HandleSeq BLinkHseq = {TypedVariableLink, findpattern, writepattern};
			Handle BindLink = as.add_link(BIND_LINK, BLinkHseq);

		//Execute rewrite query
			colornodes = bindlink(&as, BindLink);

			//Print the returned atoms	
			cout << "PrimaryColors: " << endl << colornodes->toString() << endl;
		
			


			

			TS_ASSERT(colornodes->toString() == primary_colors );
	
}


		

	


};
