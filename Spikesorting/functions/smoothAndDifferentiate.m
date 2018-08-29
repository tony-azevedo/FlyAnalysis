function spikeWaveform_ = smoothAndDifferentiate(spikeWaveform,smthw)

spikeWaveform_ = diff(spikeWaveform-spikeWaveform(1));
spikeWaveform_ = smooth(spikeWaveform_-spikeWaveform_(1),smthw);
spikeWaveform_ = diff(spikeWaveform_-spikeWaveform_(1));
spikeWaveform_(1:3) = mean(spikeWaveform_(1:20));
spikeWaveform_ = smooth(spikeWaveform_-spikeWaveform_(1),smthw);
spikeWaveform_ = [0; 0;spikeWaveform_-spikeWaveform_(1)];
