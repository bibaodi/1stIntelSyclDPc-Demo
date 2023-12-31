function [p_axial, p_lateral, p_axial_complex] = focusedBowlONeil(radius, diameter, velocity, frequency, sound_speed, density, axial_position, lateral_position)
%FOCUSEDBOWLONEIL Compute O'Neil's solution for focused bowl transducer.
%
% DESCRIPTION:
%     focusedBowlONeil calculates O'Neil's solution (O'Neil, H. Theory of
%     focusing radiators. J. Acoust. Soc. Am., 21(5), 516-526, 1949) for
%     the axial and lateral pressure amplitude generated by a focused bowl
%     transducer when uniformly driven by a continuous wave sinusoid at a
%     given frequency and normal surface velocity. 
%
%     The solution is evaluated at the positions along the beam axis given
%     by axial_position (where 0 corresponds to the transducer surface),
%     and lateral positions through the geometric focus given by
%     lateral_position (where 0 corresponds to the beam axis). To return
%     only the axial or lateral pressure, set the either axial_position or
%     lateral_position to [].
%
%     Note, O'Neil's formulae are derived under the assumptions of the
%     Rayleigh integral, which are valid when the transducer diameter is
%     large compared to both the transducer height and the acoustic
%     wavelength.
%
%     Example:
%
%         % define transducer parameters
%         radius      = 140e-3;     % [m]
%         diameter    = 120e-3;     % [m]
%         velocity    = 100e-3;     % [m/s]
%         frequency   = 1e6;        % [Hz]
%         sound_speed = 1500;       % [m/s]
%         density     = 1000;       % [kg/m^3]
% 
%         % define position vectors
%         axial_position   = 0:1e-4:250e-3;     % [m]
%         lateral_position = -15e-3:1e-4:15e-3; % [m]
% 
%         % evaluate pressure
%         [p_axial, p_lateral] = focusedBowlONeil(radius, diameter, ...
%             velocity, frequency, sound_speed, density, ...
%             axial_position, lateral_position);
% 
%         % plot
%         figure;
%         subplot(2, 1, 1);
%         plot(axial_position .* 1e3, p_axial .* 1e-6, 'k-');
%         xlabel('Axial Position [mm]');
%         ylabel('Pressure [MPa]');
%         subplot(2, 1, 2);
%         plot(lateral_position .* 1e3, p_lateral .* 1e-6, 'k-');
%         xlabel('Lateral Position [mm]');
%         ylabel('Pressure [MPa]');
%
% USAGE:
%     [p_axial, p_lateral] = focusedBowlONeil(radius, ...
%         diameter, velocity, frequency, sound_speed, density, ...
%         axial_position, lateral_position);
%     [p_axial, p_lateral, p_axial_complex] = focusedBowlONeil(radius, ...
%         diameter, velocity, frequency, sound_speed, density, ...
%         axial_position, lateral_position);
%
% INPUTS:
%     radius           - transducer radius of curvature [m]
%     diameter         - diameter of the circular transducer aperture [m]
%     velocity         - normal surface velocity [m/s]
%     frequency        - driving frequency [Hz]
%     sound_speed      - speed of sound in the propagating medium [m/s]
%     density          - density in the propagating medium [kg/m^3]
%     axial_position   - vector of positions along the beam axis where the
%                        pressure amplitude is calculated [m]
%     lateral_position - vector of positions along the lateral direction
%                        where the pressure amplitude is calculated [m]
%
% OUTPUTS:
%     p_axial          - pressure amplitude at the positions specified by
%                        axial_position [Pa]
%     p_lateral        - pressure amplitude at the positions specified by
%                        lateral_position [Pa]
%     p_axial_complex  - complex pressure amplitude at the positions
%                        specified by axial_position [Pa]
%
% ABOUT:
%     author           - Bradley Treeby
%     date             - 7th April 2016
%     last update      - 30th March 2021
%
% This function is part of the k-Wave Toolbox (http://www.k-wave.org)
% Copyright (C) 2016-2021 Bradley Treeby
%
% See also focusedAnnulusONeil, mendousse.

% This file is part of k-Wave. k-Wave is free software: you can
% redistribute it and/or modify it under the terms of the GNU Lesser
% General Public License as published by the Free Software Foundation,
% either version 3 of the License, or (at your option) any later version.
% 
% k-Wave is distributed in the hope that it will be useful, but WITHOUT ANY
% WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
% FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
% more details. 
% 
% You should have received a copy of the GNU Lesser General Public License
% along with k-Wave. If not, see <http://www.gnu.org/licenses/>.

% wavenumber
k = 2 .* pi .* frequency ./ sound_speed;

% height of rim
h = radius - sqrt( radius.^2 - (diameter ./ 2).^2 );

if ~isempty(axial_position)

    % calculate distances and constants (Eqs. 3.1 and 3.2)
    B = sqrt( (axial_position - h).^2 + (diameter ./ 2).^2 );
    d = B - axial_position;
    E = 2 ./ (1 - axial_position ./ radius);
    M = (B + axial_position)/2;

    % compute pressure (Eq. 3.1)
    P = E .* sin(k .* d ./ 2);

    % replace values where axial_position is equal to the radius with limit
    P(abs(axial_position - radius) < eps) = k .* h;

    % calculate magnitude of the on-axis pressure (Eq. 3.0)
    p_axial = density .* sound_speed .* velocity .* abs(P);
    
    % calculate complex magnitude of the on-axis pressure assuming t = 0 (Eq. 3.0)
    p_axial_complex = density .* sound_speed .* velocity .* P .* 1i .* exp(-1i .* k .* M);
    
else
    
    % return empty p_axial output if axial_position is empty
    p_axial = [];
    p_axial_complex = [];
    
end

if ~isempty(lateral_position)

    % calculate magnitude of the lateral pressure at the geometric focus
    argm = k .* lateral_position .* diameter ./ (2 .* radius);
    p_lateral = 2 .* density .* sound_speed .* velocity .* k .* h .* besselj(1, argm) ./ argm;

    % replace origin with limit
    p_lateral(lateral_position == 0) = density .* sound_speed .* velocity .* k .* h;
    
else
   
    % return empty p_lateral output if lateral_position is empty
    p_lateral = [];
    
end