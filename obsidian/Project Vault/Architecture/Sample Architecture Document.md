An Architecture document should describe a specific system, component, or other implementation of a game mechanic as it functions in the actual application. It should describe how to use the component, what it does, what it _does not_ do, and provide any other relevant information.

Unlike Design documents, Architecture documents should be fairly structured, allowing for easy reference.

Below is the general structure an Architecture document should follow:
## Component Summary
Briefly describe the component and the problem it solves.
* What is the Component called?
* Where is the Component used in-game?
* Where is the Component found in the project directory?
## What this Component Does
* Describe what problem the component solves in more detail and how it goes about it.
* Discuss what data and procedures the component is responsible for.
## What this Component Does _Not_ Do
* Describe the limits of this component's responsibilities. Clearly define the line between what is in and out of its scope.
* If this component fulfills responsibilities for other components, describe them here (and why this component takes over responsibility from the dependent component)
* If this component delegates responsibilities to other components, describe them here (and why this component passes responsibility to the delegate component)
## Using this Component
* If the Component can be used by various systems, describe how to use it in this section.
* **Optional**: This section can be omitted if the component cannot be used outside of its native context.
## Additional Notes
* Describe any additional key information that should be shared about this component
* **Optional**: This section may be omitted if the component is simple or if the rest of the document fully covers the component's features
## See Also
* Link other relevant internal pages
* Link external pages that discuss topics relevant to the problem the component solves
* Link research articles, help forum posts, etc. that were used to help create the component
* **Optional**: This section may be omitted if the component is simple, independent, or if this document otherwise fully captures all relevant information about the component.