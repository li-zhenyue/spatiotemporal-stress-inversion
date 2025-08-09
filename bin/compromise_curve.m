function [ residual, model_length ] = compromise_curve( G, d, L, lamuda )


n_lamuda = length( lamuda );
residual = nan( n_lamuda, 1 );
model_length = nan( n_lamuda, 1 );
for i = 1 : n_lamuda
    m = ( G' * G + lamuda( i )^2 * ( L' * L ) ) \ G' * d;
    d_syn = G * m;
    residual( i ) = var( d - d_syn );
    model_length( i ) = norm( L * m );
end

figure( 'color', 'w' )
hold on
plot( model_length, residual, 'color', 'k', 'LineWidth', 1 )
plot( model_length, residual, '^', 'MarkerSize', 7, 'LineWidth', 1, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'w' )
text( model_length, residual, num2str( lamuda' ), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left' )
xlabel( 'Model length' )
ylabel( 'Data variance' )
set( gca, 'position', [0.15, 0.15, 0.7, 0.7] ,'fontsize', 12, 'LineWidth', 1, 'TickLength', [0.015, 0.01] )

r = 0.07;
xlim( [ min( model_length ) - ( max( model_length ) - min( model_length ) ) * r, ...
    max( model_length ) + ( max( model_length ) - min( model_length ) ) * r, ] )
ylim( [ min( residual ) - ( max( residual ) - min( residual ) ) * r, ...
    max( residual ) + ( max( residual ) - min( residual ) ) * r, ] )
box on


end




