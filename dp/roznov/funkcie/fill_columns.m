function ret = fill_columns(varargin) 	% argumentmi su jednotlive struktury (wafre)
	ret.wafer=[];
	ret.angle=[];
	ret.dose=[];
	ret.FSIenergy=[];
	ret.BSIanneal=[];
	for i=1:nargin
		ret.wafer=[ret.wafer; varargin{i}.wafer];
		ret.angle=[ret.angle, varargin{i}.angle];
		ret.dose=[ret.dose, varargin{i}.dose];
		ret.FSIenergy=[ret.FSIenergy, varargin{i}.FSIenergy];
		ret.BSIanneal=[ret.BSIanneal, varargin{i}.BSIanneal];

		ret.Eoff{i}=varargin{i}.values.Eoff;
		ret.Eon{i}=varargin{i}.values.Eon;
		ret.EoffmJ{i}=varargin{i}.values.EoffmJ;
		ret.EonmJ{i}=varargin{i}.values.EonmJ;

		ret.Vpeak{i}=varargin{i}.values.Vpeak;
		ret.didt_on_Aus{i}=varargin{i}.values.didt_on_Aus;
		ret.didt_off_Aus{i}=varargin{i}.values.didt_off_Aus;
		
		ret.Toff{i}=varargin{i}.values.Toff;
		ret.Ton{i}=varargin{i}.values.Ton;

		ret.T12{i}=varargin{i}.values.T12;
		ret.T23{i}=varargin{i}.values.T23;
		ret.T34{i}=varargin{i}.values.T34;
		ret.T45{i}=varargin{i}.values.T45;
		ret.T67{i}=varargin{i}.values.T67;
		ret.T78{i}=varargin{i}.values.T78;
		ret.T89{i}=varargin{i}.values.T89;
		ret.T910{i}=varargin{i}.values.T910;



		if(!isfield(varargin{i}.values, "BV"))
			ret.BV{i} = 0;
		else
			ret.BV{i} = varargin{i}.values.BV;
		endif
	endfor
endfunction
