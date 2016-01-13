function displayNetwork(net)
% Visualize neural network

markersize=100;
linewidth=10;
hold on;

% convert network to Matlab standard network format
net.IW{1}=net.Wi(:,1:end-1);
net.b{1}=net.Wi(:,end);
net.LW{2,1}=net.Wo(:,1:end-1);
net.b{2}=net.Wo(:,end);
net.layers{1}.transferFcn='tansig';
net.layers{2}.transferFcn='purelin';

% Define plot locations of the neural network nodes
[Nhidden,Ninput]=size(net.IW{1});
y_posInput=linspace(0,1,Ninput+2);
y_posInput=fliplr(y_posInput(2:end-1));
x_posInput=0*ones(Ninput,1);

y_posHidden=linspace(0,1,Nhidden+2);
y_posHidden=fliplr(y_posHidden(2:end-1));
x_posHidden=0.5*ones(Nhidden,1);

[Noutput,Nhidden]=size(net.LW{2,1});
y_posOutput=linspace(0,1,Noutput+2);
y_posOutput=fliplr(y_posOutput(2:end-1));
x_posOutput=1*ones(Noutput,1);

% Plot edges from Input to Hidden layer
W=net.IW{1};
maxW=max(max(abs(W)));
for n=1:Ninput
    for nn=1:Nhidden
        if W(nn,n)>0
            plot([x_posInput(n) x_posHidden(nn)],[y_posInput(n) y_posHidden(nn)],'-g','LineWidth',linewidth*abs(W(nn,n))/maxW);
        else
            plot([x_posInput(n) x_posHidden(nn)],[y_posInput(n) y_posHidden(nn)],'-r','LineWidth',linewidth*abs(W(nn,n))/maxW);
        end
        text((0.35*x_posInput(n)+0.65*x_posHidden(nn)),(0.35*y_posInput(n)+0.65*y_posHidden(nn)),['w_{' num2str(nn) ',' num2str(n) '}^{(Hidden)}=' num2str(W(nn,n))],'HorizontalAlignment','center');
    end
end

% Plot edges from Hidden to Output layer
W=net.LW{2,1};
maxW=max(max(abs(W)));
for n=1:Nhidden
    for nn=1:Noutput
        if W(nn,n)>0
            plot([x_posHidden(n) x_posOutput(nn)],[y_posHidden(n) y_posOutput(nn)],'-g','LineWidth',linewidth*abs(W(nn,n))/maxW);
        else
            plot([x_posHidden(n) x_posOutput(nn)],[y_posHidden(n) y_posOutput(nn)],'-r','LineWidth',linewidth*abs(W(nn,n))/maxW);
        end
        text((0.35*x_posHidden(n)+0.65*x_posOutput(nn)),(0.35*y_posHidden(n)+0.65*y_posOutput(nn)),['w_{' num2str(nn) ',' num2str(n) '}^{(Output)}='  num2str(W(nn,n))],'HorizontalAlignment','center');
    end
end


% Plot input units
plot(x_posInput,y_posInput,'.y','Markersize',markersize);
text(0,1,'Input Layer','HorizontalAlignment','center','FontWeight','bold');
for k=1:Ninput
    text(x_posInput(k),y_posInput(k),['x_{' num2str(k) '}'],'HorizontalAlignment','center');
end


% Plot hidden units
plot(x_posHidden,y_posHidden,'.y','Markersize',markersize);
text(0.5,1,{'Hidden Layer', ['transfer function: Tansig' ]},'HorizontalAlignment','center','FontWeight','bold');
for k=1:Nhidden
    text(x_posHidden(k),y_posHidden(k),{['H_{' num2str(k) '}'], ['w_{' num2str(k) ',0}^{(Hidden)}=' num2str(net.b{1}(k))]},'HorizontalAlignment','center');
end

% Plot output units
plot(x_posOutput,y_posOutput,'.y','Markersize',markersize);
text(1,1,{'Output Layer', ['transfer function: Linear']},'HorizontalAlignment','center','FontWeight','bold');
for k=1:Noutput
    text(x_posOutput(k),y_posOutput(k),{['y_' num2str(k)], ['w_{' num2str(k) ',0}^{(Output)}=' num2str(net.b{2}(k))]},'HorizontalAlignment','center');
end
axis([0 1 0 1]);
axis off;
