class BashMetadataHook < Mumukit::Hook
  def metadata
    {language: {
        name: 'bash',
        icon: {type: 'devicon', name: 'bash'},
        version: '4.3.48(1)-release',
        extension: 'sh',
        ace_mode: 'bassh',
        prompt: '$'
    },
     test_framework: {
         name: 'metatest',
         test_extension: 'yml'
     }}
  end
end
