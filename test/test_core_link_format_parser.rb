require 'test/unit'
require 'core_link_format_parser'

class CoRELinkParserTest < Test::Unit::TestCase
  def test_parse_single_res
    test_res_string = '</s/lt>;rt="gobi.sen.lt";if="core.s"'
    ri = CoRELinkFormatParser.generate_resource_information(test_res_string)
    assert_equal('/s/lt', ri.link)
    assert_equal('core.s', ri.interface)
    assert_equal('gobi.sen.lt', ri.resource_type)

    test_res_string = '</s/lt2>"'
    ri = CoRELinkFormatParser.generate_resource_information(test_res_string)
    assert_equal('/s/lt2', ri.link)
    assert_equal('', ri.interface)
    assert_equal('', ri.resource_type)
  end

  def test_malformed_single_res
    test_res_string = '</s/'
    assert_raise CoRELinkParseException do
      CoRELinkFormatParser.generate_resource_information(test_res_string)
    end

    test_res_string = ''
    assert_raise CoRELinkParseException do
      CoRELinkFormatParser.generate_resource_information(test_res_string)
    end

    # TODO: fix parser to pass this:
    # links that include , or ;
    #
    # test_res_string = '</s/lt/namewith;>;rt="gobi.sen.lt";if="core.s"'
    # res_array = CoRELinkFormatParser.parse_core_link_format(test_res_string)
    # assert_equal('/s/lt/namewith;', res_array[0].link)
    # assert_equal(:sensor, res_array[0].interface)
    # assert_equal('gobi.sen.lt', res_array[0].resource_type)
  end

  def test_parse_multiple_res
    test_res_string = '</sensors/temp>;rt="temperature-c";if="core.s",'\
                      '</sensors/light>;rt="light-lux";if="core.s"'
    res = CoRELinkFormatParser.parse_core_link_format(test_res_string)
    assert_equal(2, res.size)
    assert_equal('/sensors/light', res[1].link)
    assert_equal('core.s', res[1].interface)

    assert_equal('core.s', res[0].interface)
  end

  # Test with data from coap://coap.me/.well-known/core
  # rubocop:disable MethodLength
  # rubocop:disable LineLength
  def test_coap_me
    coap_me_data = "</test>;rt=\"test\";ct=0,"\
                    "</validate>;rt=\"validate\";ct=0,"\
                    "</hello>;rt=\"Type1\";ct=0;if=\"If1\","\
                    "</bl%C3%A5b%C3%A6rsyltet%C3%B8y>;rt=\"bl\xC3\xA5b\xC3\xA6rsyltet\xC3\xB8y\";ct=0,"\
                    "</sink>;rt=\"sink\";ct=0,"\
                    "</separate>;rt=\"separate\";ct=0,"\
                    "</large>;rt=\"Type1 Type2\";ct=0;sz=1700;if=\"If2\","\
                    "</secret>;rt=\"secret\";ct=0,"\
                    "</broken>;rt=\"Type2 Type1\";ct=0;if=\"If2 If1\","\
                    "</weird33>;rt=\"weird33\";ct=0,"\
                    "</weird44>;rt=\"weird44\";ct=0,"\
                    "</weird55>;rt=\"weird55\";ct=0,"\
                    "</weird333>;rt=\"weird333\";ct=0,"\
                    "</weird3333>;rt=\"weird3333\";ct=0,"\
                    "</weird33333>;rt=\"weird33333\";ct=0,"\
                    "</123412341234123412341234>;rt=\"123412341234123412341234\";ct=0,"\
                    "</location-query>;rt=\"location-query\";ct=0,"\
                    "</create1>;rt=\"create1\";ct=0,"\
                    "</large-update>;rt=\"large-update\";ct=0,"\
                    "</large-create>;rt=\"large-create\";ct=0,"\
                    "</query>;rt=\"query\";ct=0,"\
                    "</seg1>;rt=\"seg1\";ct=40,</path>;rt=\"path\";ct=40,"\
                    "</location1>;rt=\"location1\";ct=40,"\
                    "</multi-format>;rt=\"multi-format\";ct=0,"\
                    "</3>;rt=\"3\";ct=50,"\
                    "</4>;rt=\"4\";ct=50,"\
                    "</5>;rt=\"5\";ct=50"
    res = CoRELinkFormatParser.parse_core_link_format(coap_me_data)
    assert_equal(28, res.size)

    assert_equal('/hello', res[2].link)
    assert_equal('Type1', res[2].resource_type)
  end
  # rubocop:enable MethodLength
  # rubocop:enable LineLength
end
