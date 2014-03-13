class NewBeUpMatcherSummary < ActiveRecord::Migration
  def up
    m = Matcher.find_by(code: 'be_up')
    m.summary = 'Check for an &ldquo;OK&rdquo; (<code>200</code>) response, following up to four redirects.'
    m.save!
  end
end
