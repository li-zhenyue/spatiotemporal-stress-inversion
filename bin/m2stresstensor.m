function ST = m2stresstensor( m )

m( 6 ) = - m( 1 ) - m( 4 );
ST = [ m( 1 ), m( 2 ), m( 3 );
       m( 2 ), m( 4 ), m( 5 );
       m( 3 ), m( 5 ), m( 6 ) ];
   
end