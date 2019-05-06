s.options.numOutputBusChannels = 32;
s.options.outDevice_("Scarlett 2i2 USB");

//read in a folder of short samples of a chopped up audio file
(
d = Dictionary.new;
d.add(\stabPad ->
	PathName("/Users/seanwalker/Desktop/Live/black Project/Samples/Processed/Crop/stabPad/").entries.collect({
		arg sf;
		Buffer.read(s, sf.fullPath);
	});
)
)

//read in a folder of short samples of a chopped up audio file
(
e = Dictionary.new;
e.add(\stabPad ->
	PathName("/Users/seanwalker/Desktop/Live/black Project/Samples/Processed/Consolidate/supercollider/").entries.collect({
		arg sf;
		Buffer.read(s, sf.fullPath);
	});
)
)


(
SynthDef.new(\playBufHorizontal, {
	arg buf=0, rate=1, amp=1, out=0;
	var sig;
	sig = PlayBuf.ar(2, buf, BufRateScale.ir(buf) * rate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig); //play buffer out of speakers 0,5,10,15 which are positioned in a vertical row
	Out.ar(out+5, sig);
	Out.ar(out+10, sig);
	Out.ar(out+15, sig);
}).add;
)




(
Pdef(
	\rhythm,
	Pbind(
		\instrument, \playBufHorizontal,
		\dur, Prand([1/8], inf),
		\buf, Pseq([Pseries(0, 1, 127)], inf),
		\out, Pseq([0,1,2,3,4], inf),
		\rate, Pseq([1.0], inf),
		\amp, 0.3,
	);
).play(quant:1.875);
// ).stop;
)

////////////////////
(
SynthDef.new(\playBuf, {
	arg buf=0, rate=1, amp=1, out=0;
	var sig;
	sig = PlayBuf.ar(2, buf, BufRateScale.ir(buf) * rate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

//drums reverb
(
SynthDef.new(\drumsReverb, {
	arg in, out=0, mix=1.0;
	var sig;
	sig = In.ar(in, 2);
	sig = FreeVerb.ar(sig, mix, 0.8, 0.55)!2;
	Out.ar(out, sig);
}).add;
)

(
Pdef(
	\drums,
	Pbind(
		\instrument, \playBuf,
		\dur, Pseq([1/8, 1/8, 1/4, 1/4], inf), //, 0.07, 0.14
		\buf, Prand([129, 128], inf),
		\out, Pseq([20,21,22,23,24]-5, inf), //, 21,22,23,24
		\rate, Prand([1.0], inf),
		\amp, 0.25,
	);
//).quant_(1.875);
).play(quant:1.875);
)

(
Pdef(
	\hats,
	Pbind(
		\instrument, \playBuf,
		\dur, Pseq([1/4, 1/8, 1/8], inf), //, 0.07, 0.14
		\buf, Prand([133, 130], inf),
		\out, Pseq([20,21,22,23,24], inf), //, 21,22,23,24
		\rate, Prand([1.0, Pwhite(0.1, 0.70, 100)], inf),
		\amp, 0.25,
	);
// ).quant_(1.875);
).play(quant:1.875);
//).stop;
)

y = Synth.new(\drumsReverb, [\in, 20]);
z = Synth.new(\drumsReverb, [\in, 21]);
a = Synth.new(\drumsReverb, [\in, 20, \out, 0]);
a.set(\out, 15);
a.free;