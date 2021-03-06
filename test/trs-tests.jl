
using Base.Test
using Jlsca.Trs

function createTmpFile(tail)
  return @sprintf("/tmp/tmp%s%s", String([UInt8(rand(0x30:0x5a)) for i in 1:10]), tail)
end

function testInspectorTrace()
  dataSpace = 7
  sampleType = Int16
  numberOfSamplesPerTrace = 29
  numberOfTraces = 11
  traceFilename = createTmpFile("bob.trs")

  allSamples = reshape([rand(Int16) for i in 1:(numberOfSamplesPerTrace*numberOfTraces)], (numberOfTraces,  numberOfSamplesPerTrace))
  allData = reshape([rand(UInt8) for i in 1:(dataSpace*numberOfTraces)], (numberOfTraces, dataSpace))

  trs = InspectorTrace(traceFilename, dataSpace, sampleType, numberOfSamplesPerTrace)

  for i in 1:numberOfTraces
    trs[i] = (allData[i,:], allSamples[i,:])
    @test trs[i] == (allData[i,:], allSamples[i,:])
  end

  close(trs)

  trs2 = InspectorTrace(traceFilename)

  @test length(trs2) == numberOfTraces

  for i in 1:numberOfTraces
    @test trs2[i] == (allData[i,:], allSamples[i,:])
  end

  close(trs2)

  rm(traceFilename)
end

function testSplitBinary()
  dataSpace = 7
  sampleType = Int16
  numberOfSamplesPerTrace = 29
  numberOfTraces = 11
  samplesFilename = createTmpFile(@sprintf("_%s_%dt.bin", sampleType, numberOfTraces))
  dataFilename = createTmpFile(@sprintf("_UInt8_%dt.bin", numberOfTraces))

  allSamples = reshape([rand(Int16) for i in 1:(numberOfSamplesPerTrace*numberOfTraces)], (numberOfTraces,  numberOfSamplesPerTrace))
  allData = reshape([rand(UInt8) for i in 1:(dataSpace*numberOfTraces)], (numberOfTraces, dataSpace))

  trs = SplitBinary(dataFilename, dataSpace, samplesFilename, numberOfSamplesPerTrace, sampleType, numberOfTraces, true)

  for i in 1:numberOfTraces
    trs[i] = (allData[i,:], allSamples[i,:])
    @test trs[i] == (allData[i,:], allSamples[i,:])
  end

  close(trs)

  trs2 = SplitBinary(dataFilename, samplesFilename)

  @test length(trs2) == numberOfTraces

  for i in 1:numberOfTraces
    @test trs2[i] == (allData[i,:], allSamples[i,:])
  end

  close(trs2)

  rm(samplesFilename)
  rm(dataFilename)
end

function testInspectorMM()
  dataSpace = 7
  sampleType = UInt8
  numberOfSamplesPerTrace = 29
  numberOfTraces = 11
  traceFilename = createTmpFile("bob.trs")

  allSamples = reshape([rand(sampleType) for i in 1:(numberOfSamplesPerTrace*numberOfTraces)], (numberOfTraces,  numberOfSamplesPerTrace))
  allData = reshape([rand(UInt8) for i in 1:(dataSpace*numberOfTraces)], (numberOfTraces, dataSpace))

  trs = InspectorTrace(traceFilename, dataSpace, sampleType, numberOfSamplesPerTrace)

  for i in 1:numberOfTraces
    trs[i] = (allData[i,:], allSamples[i,:])
    @test trs[i] == (allData[i,:], allSamples[i,:])
  end

  close(trs)

  trs2 = InspectorTraceMM(traceFilename)

  @test length(trs2) == numberOfTraces

  for i in 1:numberOfTraces
    @test trs2[i] == (allData[i,:], allSamples[i,:])
  end

  close(trs2)

  rm(traceFilename)end


testInspectorTrace()
testSplitBinary()
testInspectorMM()
