this.character_trait <- this.inherit("scripts/skills/skill", {
	m = {
		Titles = [],
		Excluded = []
	},
	function isExcluded( _id )
	{
		return this.m.Excluded.find(_id) != null;
	}

	function create()
	{
		this.m.Type = this.Const.SkillType.Trait;
		this.m.Order = this.Const.SkillOrder.Trait + this.Math.rand(0, 500);
	}

	function addTitle()
	{
		local actor = this.getContainer().getActor();

		if (actor.getTitle().len() == 0 && this.m.Titles.len() != 0 && this.Math.rand(1, 100) <= 10)
		{
			actor.setTitle(this.m.Titles[this.Math.rand(0, this.m.Titles.len() - 1)]);
		}
	}

});

