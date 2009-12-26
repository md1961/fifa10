class ErrorExplanation

  attr_accessor :title, :texts, :lists

  def initialize(title, texts, lists)
    @title = title
    @texts = texts
    @lists = lists
  end

  def to_s
    title = @title.blank? ? "" : "<h2>#{@title}</h2>\n"
    texts = @texts.empty? ? "" : @texts.join('<br />') + "\n"
    lists = @lists.empty? ? "" : "<ul>\n<li>" + @lists.join("</li>\n<li>") + "</li>\n</ul>"
    return <<-END
      <div id="errorExplanation">
        #{title}
      <p>
        #{texts}
        #{lists}
      </p>
      </div>
    END
  end
end

