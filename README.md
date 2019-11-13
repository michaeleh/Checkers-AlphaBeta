# Checkers-AlphaBeta

Checkers alpha beta implemitation in prolog
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
        		"isQueen":false

        	},
        	{
        		"i":11,
        		"j":21,
        		"color":"black",
        		"isQueen":true

        	}

    	],
    "settings":
        {
    	    "level":"easy",
    	    "rows": 8
        }

}
```

it will convert it to a structure of such:

```
 game([piece(1,2,"white",false),piece(11,21,"black",true)],settings(6,9))
```
