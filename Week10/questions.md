1. How does the remote client determine when a command's output is fully received from the server, and what techniques can be used to handle partial reads or ensure complete message transmission?

_The remote client determines when a command's output is full received from the server by the EOF or EOT signal, exit, stop-server command, and by timeouts if the server closes the connection. A technique that can be used to handle partial reads to ensure complete message transmission by looping/continously reading until the expected data is recieved._

2. This week's lecture on TCP explains that it is a reliable stream protocol rather than a message-oriented one. Since TCP does not preserve message boundaries, how should a networked shell protocol define and detect the beginning and end of a command sent over a TCP connection? What challenges arise if this is not handled correctly?

_A netwokred shell protocol can define and detect the beginning and the end or a command by using special characters like \n to mark the end of each command. If this is not handled corrected there could be multiple commands that may mix together. There could also be missing data._

3. Describe the general differences between stateful and stateless protocols.

_The main difference is that stateful protocols keep track of previous actions/data, and remebers the state of the connection between requests. Stateless protocols don't keep track of previous actions where each request is independent._

4. Our lecture this week stated that UDP is "unreliable". If that is the case, why would we ever use it?

_UDP is faster than TCP so it may be good for situations where speed is more important._

5. What interface/abstraction is provided by the operating system to enable applications to use network communications?

_Sockets are provided by the operating system to enable applications to use network communications._