% exercise 3.2.2

% Generate two data objects with M random attributes
M = 5;
x = rand(1,M);
y = rand(1,M);

% Two constants
a = 1.5;
b = 1.5;

% Check the statements in the exercise
similarity(x,y,'cos') - similarity(a*x,y,'cos')
similarity(x,y,'ext') - similarity(a*x,y,'ext')
similarity(x,y,'cor') - similarity(a*x,y,'cor')
similarity(x,y,'cos') - similarity(b+x,y,'cos')
similarity(x,y,'ext') - similarity(b+x,y,'ext')
similarity(x,y,'cor') - similarity(b+x,y,'cor')