function ret = sw_eval_wafer(measured, trigd_n)
	tr = trigd_n;
	tus=measured.tus;
	dt=measured.dt;
	p=measured.p;
	ret.T12=(tus(tr(2,:))-tus(tr(1,:)))';
	ret.T23=(tus(tr(3,:))-tus(tr(2,:)))';
	ret.T34=(tus(tr(4,:))-tus(tr(3,:)))';
	ret.T45=(tus(tr(5,:))-tus(tr(4,:)))';
	ret.Toff=(tus(tr(5,:))-tus(tr(1,:)))';

	ret.T67=(tus(tr(7,:))-tus(tr(6,:)))';
	ret.T78=(tus(tr(8,:))-tus(tr(7,:)))';
	ret.T89=(tus(tr(9,:))-tus(tr(8,:)))';
	ret.T910=(tus(tr(10,:))-tus(tr(9,:)))';
	ret.Ton=(tus(tr(10,:))-tus(tr(6,:)))';

	ret.Vpeak = max(measured.vc);
	ret.didt_off_Aus = (measured.ic(trigd_n(4,:)) - measured.ic(trigd_n(3,:))) ./ ret.T34;
	ret.didt_on_Aus = (measured.ic(trigd_n(8,:)) - measured.ic(trigd_n(7,:))) ./ ret.T78;

	for i=1:columns(p)
		ret.Eoff(i)=sum(p(:,i)(tr(1,i):tr(5,i))*dt);
		ret.Eon(i)=sum(p(:,i)(tr(6,i):tr(10,i))*dt);
	endfor

	ret.EoffmJ=ret.Eoff*1000;
	ret.EonmJ=ret.Eon*1000;

endfunction
