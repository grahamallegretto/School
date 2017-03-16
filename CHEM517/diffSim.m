function [z,T] = diffSim( L, questionNum, alpha, rateConstant, appliedPotential, toPlot )
%DIFFUSION Numerical approximation of diffusion
%   Detailed explanation goes here

if questionNum < 5
    close all
    figure
end

% Parameters
dma = 0.45; % Ddt/(dx)^2
dmb =  dma;

% Constants
leng = floor(4.4*sqrt(dma*L) + 1); % Used to ensure same dimensionless x 
                                   % value for different L values for
                                   % plotting
x = (0:leng-1)/sqrt(dma*L);
eNorm = appliedPotential/0.025693; % Normalized Potential
rateConstantA = rateConstant*exp(-alpha*eNorm);     % Forward rate constant
rateConstantB = rateConstant*exp((1-alpha)*eNorm);  % Reverse rate constant

% Array declaration
Fa = ones(L,1);
Fb = zeros(L,1);
z = zeros(L,1);
surfaceFa = zeros(L,1);

% Main Loop
for k = 1:L
    surfaceFa(k) = Fa(1);
    
    % Diffusion past the first box  
    Fa(2:end-1) = Fa(2:end-1) + dma.*(Fa(1:end-2) - 2*Fa(2:end-1) + Fa(3:end));
    Fb(2:end-1) = Fb(2:end-1) + dmb.*(Fb(1:end-2) - 2*Fb(2:end-1) + Fb(3:end));
    
    % Diffusion into the first box
    Fa(1) = Fa(1) + dma*(Fa(2) - Fa(1));
    Fb(1) = Fb(1) + dmb*(Fb(2) - Fb(1));
    
    % If it's question 2 or 3, use only mass-transport limited case
    if ( questionNum < 4 )
        % Questions 2,3
        z(k) = sqrt(L/dma)*Fa(1);
        Fb(1) = Fb(1) + Fa(1);
        Fa(1) = 0;
    else
        % Heterogeneous Kinetics
        
        % Current for heterogeneous kinetics
        z(k) = rateConstantA*Fa(1) - rateConstantB*Fb(1); 
        dRxn = z(k)*sqrt(dma/L);    % Concentration change from reaction
            
        % Check if the change in the products/reactants is larger than what
        % the nernst equation predicts, if it is, the reaction will be
        % reversible.
        if( (Fa(1) - dRxn) <  (1/(1+exp(-eNorm))) )
            z(k) = sqrt(L/dma)*(Fa(1) - (1/(1+exp(-eNorm))) );
            Fa(1) = (1/(1+exp(-eNorm)));
            Fb(1) = 1 - Fa(1);
        else
            Fa(1) = Fa(1) - dRxn;
            Fb(1) = Fb(1) + dRxn;
        end
    end
   
    % Plot for inspection 
    if( toPlot && ( mod(k,L/100) == 0 ) )
        plot( x, Fa(1:leng), x, Fb(1:leng) );
        xlabel('Dimensionless Distance');
        ylabel('Dimensionless Concentration');
        pause(0.05); 
    end
    
    % Plot for Questions
    if( k == floor(L/2) && (questionNum < 5) )
        
        subplot(2,2,[1 3]);
        plot( x, Fa(1:leng), x, Fb(1:leng));
        xlabel('Dimensionless Distance');
        ylabel('Dimensionless Concentration');
        legend( 'F_a', 'F_b' );
    
        % Add analytical version if it's question 3
        if( questionNum == 3 )
            hold on
            plot( x, erf((x./2).*sqrt(L./k)) );
            legend( 'F_a', 'F_b', 'Analytical' );
            hold off
        end
    end
end

% Plot current-time curve
T = ((1:L)-0.5)./L;
zCott = (pi.*T).^(-1/2);

if( questionNum < 5 )
    if( questionNum > 3 )
        hold on
        subplot(2,2,[1,3]);
        fa = (1/(1+exp(eNorm)));

        plot([x(1) x(end)],[fa fa]);
        plot([x(1) x(end)],[1-fa 1-fa]);
        legend('F_a','F_b','F_b_N_e_r_s_t_i_a_n','F_a_N_e_r_s_t_i_a_n');
        hold off

    end
    subplot(2,2,2)
    plot(T,z(1:L),T,zCott);
    xlabel('t/t_k');
    ylabel('Z');
    legend('Z','Z Cottrell');
    
    subplot(2,2,4);
    plot(T,z(1:L)./zCott');
    xlabel('t/t_k');
    ylabel('Z/Z_C_o_t_t');
end

