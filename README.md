# Checkers-AlphaBeta

Checkers alpha beta implemitation in prolog based on <a href="https://cs.huji.ac.il/~ai/projects/old/English-Draughts.pdf">this article</a>

The clinet side in java <a href="https://github.com/ilanlevi/prolog-final-project"> HERE </a>

## json format

from a json in a format of such:

```
{
    "state":
        [
        	{
        		"i":1,
        		"j":2,
        		"color":"white",
        		"isQueen":0

        	},
        	{
        		"i":11,
        		"j":21,
        		"color":"black",
        		"isQueen":1

        	}

    	],
    "settings":
        {
    	    "level":6,
    	    "rows": 9
        }

}
```

it will convert it to a structure of such:

```
 game([piece(1,2,"white",0),piece(11,21,"black",1)],settings(6,9))
```
