class VariantDetailPresenter < VariantIndexPresenter
  def as_json(opts = {})
    super.merge(
      {
        evidence_items: variant.evidence_items.map { |ei| EvidenceItemPresenter.new(ei) },
        variant_groups: variant.variant_groups.map { |vg| VariantGroupPresenter.new(vg) },
        lifecycle_actions: LifecyclePresenter.new(variant),
        errors: variant.errors.to_h
      }
    )
  end
end
