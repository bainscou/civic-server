class GeneTsvPresenter
  def self.objects
    Gene.joins(variants: [:evidence_items]).uniq
  end

  def self.headers
    ['name', 'entrez_id', 'description']
  end

  def self.row_from_object(gene)
    [
      gene.name,
      gene.entrez_id,
      gene.description.gsub("\n", ' ')
    ]
  end

  def self.file_name
    'GeneSummaries.tsv'
  end
end
