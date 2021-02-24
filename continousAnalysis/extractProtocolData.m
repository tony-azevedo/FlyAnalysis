function extractProtocolData(file,trial)

cde = ContinuousDataExtractor(file);
cde.extractProtocolFiles(trial);