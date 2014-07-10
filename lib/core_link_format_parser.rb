
CoRELinkParseException = Class.new(Exception)

##
# representation of a resource discovered via core-link-format
class ResourceInformation
  class << self; attr_reader :interface_types; end

  attr_accessor :interface, :resource_type, :link
end

##
# Parser for the core-link-format
# see http://tools.ietf.org/html/rfc6690
# implements only a small part of the rfc right now
class CoRELinkFormatParser
  def self.parse_core_link_format(core_link_string)
    resource_information_array = []

    core_link_string.split(',').each do |res_item|
      resource_information_array << generate_resource_information(res_item)
    end

    resource_information_array
  end

  def self.generate_resource_information(res_str)
    new_res_info = ResourceInformation.new
    fail CoRELinkParseException, 'empty string' if res_str.size <= 0

    link_match = /<(.+?)>/.match(res_str)
    fail CoRELinkParseException, 'No link to resource found' unless link_match
    new_res_info.link = link_match[1]

    parameters = generate_parameter_hash(res_str)

    new_res_info.interface = parameters['if'] || ''
    new_res_info.resource_type = parameters['rt'] || ''

    new_res_info
  end

  private

  def self.generate_parameter_hash(param_str)
    splitted_str = param_str.split(';')
    parameters = {}
    splitted_str.drop(1).each do |item|
      parameter_match = /(.+?)="(.+?)"/.match(item)
      parameters[parameter_match[1]] = parameter_match[2] if parameter_match
    end

    parameters
  end
end
