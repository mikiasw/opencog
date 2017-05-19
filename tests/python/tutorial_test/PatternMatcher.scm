; Test utilities for PatternMatcherUTest.cxxtest
; The pattern matcher is the query engine that is used to find Atoms in Atomspace that fit 
; into a certain template or pattern.
; The scheme interface to the PM is implemented by the functions: cog-satisfy, 
; cog-satisfying-set and cog-bind 
;


(use-modules (ice-9 readline)) 
(activate-readline)
(add-to-load-path "/usr/local/share/opencog/scm")
(add-to-load-path ".")
(use-modules (opencog))
(use-modules (opencog query))
(use-modules (opencog exec))
;END Boilerplate code

(display "-----------------------------------------------------------------------")
(newline)(newline)
;Utility function to create InheritanceLinks
(define (typedef type instance) 
	(InheritanceLink 
		(ConceptNode instance) 
		type
	)
)

;Types of entities
(define color 
	(ConceptNode "Color")
)

(define animal
	(ConceptNode "Animal")
)

;Some instances of entities
(typedef color "Blue")
(typedef color "Green")
(typedef color "Red")

(typedef animal "fish")
(typedef animal "dog")
(typedef animal "cat")
;(typedef animal"petnode")
;Define a pattern that is satisfiable by colors
(define colornode
	(SatisfactionLink
		;Declare varibales [optional]
		(VariableNode "$color")
		;The pattern that the variable must satisfy
		(InheritanceLink
			(VariableNode "$color")
			(ConceptNode "Color")
		)
	)
)
; Specify a pattern 
;Define a pattern that is satisfiable by colors
(define animalnode
	(SatisfactionLink
		;Declare varibales [optional]
		(VariableNode "$animal")
		;The pattern that the variable must satisfy
		(InheritanceLink
			(VariableNode "$animal")
			(ConceptNode "Animal")
		)
	)
)

(define rewrite 
	(BindLink
		;Declare the variables [optional]
		(VariableNode "$denizen")
		;Declare the pattern used to ground the variables
		(InheritanceLink
			(VariableNode "$denizen")
			(ConceptNode "Animal")
		)
		;If a match is found for the pattern then we want
		;to add the following hypergraph ot the Atomspace
		(InheritanceLink
			(VariableNode "$denizen")
			(ConceptNode "Pet")
		)
	)
)
;Get the list of pets in the Atomspace
(define petnode
	(SatisfactionLink
		;Declare varibales
		;This is how you specify that the VariableNode "$animal"
		;should only be grounded by a ConceptNode. We are constraining
		;the type of the VariableNode to a ConceptNode.
		(TypedVariableLink
			(VariableNode "$animal")
			(TypeNode "ConceptNode")
		)
		;The pattern that the variable must satisfy
		(InheritanceLink
			(VariableNode "$animal")
			(ConceptNode "Pet")
		)
	)
)
;GetLink is just like the SatisfactionLink except that it can also
;be executed using cog-execute
(define executablepetnode
	(GetLink
		;Declare varibales [optional]
		(TypedVariableLink
			(VariableNode "$animal")
			(TypeNode "ConceptNode")
		)
		;The pattern that the variable must satisfy
		(InheritanceLink
			(VariableNode "$animal")
			(ConceptNode "Pet")
		)
	)
)

;Write with PutLink
(define writequery
	(PutLink
                ;The pattern to write into Atomspace
		(InheritanceLink
			(VariableNode "$x")
			(ConceptNode "PrimaryColor")
		)
                ;The nodes used to ground the pattern    
		(SetLink
			(ConceptNode "Red")
                        (ConceptNode "Green")
                        (ConceptNode "Blue")
		)
	)
)

;Check that the node was written
(define primarycolors
	(GetLink
		(TypedVariableLink
			(VariableNode "$color")
			(TypeNode "ConceptNode")
		)
		;The pattern that the variable must satisfy
		(InheritanceLink
			(VariableNode "$color")
			(ConceptNode "PrimaryColor")
		)
	)
)

;Combining PutLink and GetLink together
(define writequery
	(PutLink
		;The pattern to be written to Atomspace
		(InheritanceLink
			(VariableNode "$x")
			(ConceptNode "PrimaryColor")
		)
		;The GetLink to search the Atomspace for grounding nodes
		(GetLink
			;Variable declaration
			(TypedVariableLink
				(VariableNode "$color")
				(TypeNode "ConceptNode")
			)
			;Pattern
			(InheritanceLink
				(VariableNode "$color")
				(ConceptNode "Color")
			)
		)
	)
)

;Check that the node was written
(define primarycolors
	(GetLink
		(TypedVariableLink
			(VariableNode "$color")
			(TypeNode "ConceptNode")
		)
		;The pattern that the variable must satisfy
		(InheritanceLink
			(VariableNode "$color")
			(ConceptNode "PrimaryColor")
		)
	)
)

;Find all nodes that are either primarycolors or colors
(define getcolors
	(GetLink
		;Variables
		(TypedVariableLink
			(VariableNode "$obj")
			;The TypeChoice link can be used to constrain the
			;type of a node to two or more types.
			(TypeChoice
				(TypeNode "VariableNode")
				(TypeNode "ConceptNode")
			)
		)
		;Pattern: Nodes satisfying any of the choices of patterns
		;will be returned
		(ChoiceLink
			;Choice1
			(InheritanceLink 
				(VariableNode "$obj")
				(ConceptNode "Color")
			)
			;Choice2
			(InheritanceLink
				(VariableNode "$obj")
				(ConceptNode "PrimaryColor")
			)
		)
	)
)
