t=[1.14209, 1.15489, 1.19079, 1.2196, 1.10334, 1.16023, 1.13911, 1.14753, 1.21736, 1.19169, 1.10008, 1.0843, 1.11198, 1.0894, 1.12322, 1.19988, 1.15523, 1.20899, 1.21302, 1.22608, 1.24126, 1.21482, 1.1315, 1.21419, 1.08736, 1.10061, 1.1539, 1.20303, 1.10577, 1.2155, 1.10999, 1.21066, 1.14988, 1.13787, 1.15486, 1.15407, 1.00586, 0.99015, 0.943008, 0.978929, 1.04767, 0.993881, 0.901715, 1.05703, 0.928051, 0.96354, 1.01114, 1.05711, 1.02682, 1.05824, 0.976741, 0.947674, 1.01229, 0.976442, 0.917961, 0.916139, 0.918801, 0.934317, 0.954638, 1.07213, 0.907677, 0.984153, 0.977841, 1.00432, 0.960331, 0.912057, 0.975395, 1.07481, 1.00236, 1.00242, 0.994173, 0.966964, 1.02743, 1.07122 ];
brbes=[1.21696, 1.19665, 1.21071, 1.22518, 1.13512, 1.17941, 1.11212, 1.17296, 1.15541, 1.20341, 1.22212, 1.0973, 1.24568, 1.16728, 1.09839, 1.1045, 1.23497, 1.17662, 1.24942, 1.17446, 1.25137, 1.17396, 1.17379, 1.13268, 1.13435, 1.22612, 1.13979, 1.17562, 1.17463, 1.16091, 1.24784, 1.08707, 1.24508, 1.22518, 1.1559, 1.11834, 1.05508, 1.02835, 0.831898, 0.998236, 0.98546, 1.07461, 0.670679, 1.00802, 0.735332, 0.817215, 0.948375, 0.825539, 0.841582, 1.05595, 0.882114, 1.01631, 0.931988, 1.07623, 0.749873, 0.973768, 1.01604, 0.961086, 1.05658, 1.01015, 0.978085, 1.04591, 0.670679, 1.0337, 1.04202, 0.881209, 1.03937, 1.01676, 0.646185, 0.929377, 0.981219, 0.737458, 0.947661, 1.07052];
plotregression(t,brbes,'Regression')
hold on
brbdl=[1.23985, 1.21494, 1.24184, 1.24753, 1.09905, 1.18517, 1.0845, 1.16798, 1.09305, 1.22888, 1.24397, 1.07918, 1.25384, 1.15618, 1.07874, 1.08129, 1.25207, 1.17854, 1.25394, 1.1709, 1.254, 1.1577, 1.17021, 1.09942, 1.08029, 1.2467, 1.10395, 1.1741, 1.17178, 1.12347, 1.2538, 1.07769, 1.25345, 1.24753, 1.11332, 1.08405, 1.07733, 1.07526, 0.998486, 1.07351, 1.06985, 1.0775, 0.804142, 1.07457, 0.899492, 0.985789, 1.06024, 0.992448, 1.00762, 1.0771, 1.04462, 1.0772, 1.05607, 1.0775, 0.922157, 1.06833, 1.07558, 1.06535, 1.07727, 1.07526, 1.06747, 1.0768, 0.804142, 1.07733, 1.07637, 1.03107, 1.07624, 1.07427, 0.764125, 1.05394, 1.06913, 0.905954, 1.06056, 1.07748];
%plotregression(t,brbdl,'Regression')