this.hidden_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "terrain.hidden";
		this.m.Name = "Hidden";
		this.m.Description = "Ce personnage est caché par le paysage et ne peut pas être vu par ses adversaires à moins d\'être directement adjacent ou de les attaquer en premier.";
		this.m.Icon = "skills/status_effect_08.png";
		this.m.IconMini = "status_effect_08_mini";
		this.m.Type = this.Const.SkillType.Terrain | this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsHidden = false;
		this.m.IsSerialized = false;
	}

	function getDescription()
	{
		local ret = this.m.Description;
		return ret;
	}

});

