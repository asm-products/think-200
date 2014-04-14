# == Schema Information
#
# Table name: matchers
#
#  code        :string(255)      not null
#  created_at  :datetime
#  description :text
#  icon        :string(255)
#  id          :integer          not null, primary key
#  max_args    :integer          not null
#  min_args    :integer          not null
#  placeholder :string(255)
#  summary     :string(255)
#  updated_at  :datetime
#

class Matcher < ActiveRecord::Base
  has_many :expectations, dependent: :restrict_with_exception
  validates :code, :summary, uniqueness: true
  validates :code, :max_args, :min_args, :summary, :description, presence: true

  def self.for(code)
    Matcher.find_by(code: code)
  end

  def to_s
    code.gsub('_', ' ')
  end

  def summary
    self[:summary].html_safe
  end


  private

  # Create these Matchers if not in the database. This encodes the list of
  # supported matchers in one place. It allows the test database to start empty.
  # It operates seamlessly with rake db:seeds. 
  def Matcher.ensure_instances_exist
    [
      {
        code: 'be_status',
        min_args: 1,
        max_args: 1,
        summary: 'Pass if the domain/url has the given status.',
        description: 'Uses curl_lib.',
        icon: 'fa-stethoscope',
        placeholder: '200'
      },
      {
        code: 'be_up',
        min_args: 0,
        max_args: 0,
        summary: 'Check for an &ldquo;OK&rdquo; (<code>200</code>) response, following up to four redirects.',
        description: 'Uses curl_lib.',
        icon: 'fa-thumbs-o-up',
      },
      {
        code: 'have_a_valid_cert',
        min_args: 0,
        max_args: 0,
        summary: 'Serves HTTPS correctly.',
        description: 'Uses curl_lib.',
        icon: 'fa-lock'
      },
      {
        code: 'enforce_https_everywhere',
        min_args: 0,
        max_args: 0,
        summary: 'Forces visitors to use HTTPS.',
        description: 'Uses curl_lib.',
        icon: 'fa-globe'
      },
      {
        code: 'redirect_permanently_to',
        min_args: 1,
        max_args: 1,
        summary: 'Checks for a 301 redirect to a given location.',
        description: 'Uses curl_lib.',
        icon: 'fa-level-down fa-rotate-270',
        placeholder: 'somewhere.com'
      },
      {
        code: 'redirect_temporarily_to',
        min_args: 1,
        max_args: 1,
        summary: 'Checks for either a 302 or 307 redirect to a given location.',
        description: 'Uses curl_lib.',
        icon: 'fa-share',
        placeholder: 'somewhere.else.com'
      }
    ].each do |m|
      matcher = Matcher.new
      matcher.code        = m[:code]
      matcher.min_args    = m[:min_args]
      matcher.max_args    = m[:max_args]
      matcher.summary     = m[:summary]
      matcher.description = m[:description]
      matcher.icon        = m[:icon]
      matcher.placeholder = m[:placeholder]
      matcher.save
    end
  end

  # Run at class load time
  ensure_instances_exist

end
