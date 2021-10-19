this.follower <- {
	m = {
		ID = "",
		Name = "",
		Description = "",
		Effects = [],
		Requirements = [],
		Image = "",
		Cost = 0
	},
	function getID()
	{
		return this.m.ID;
	}

	function getOrder()
	{
		return this.m.Order;
	}

	function getName()
	{
		return this.m.Name;
	}

	function getDescription()
	{
		return this.m.Description;
	}

	function getImage()
	{
		return this.m.Image;
	}

	function getEffects()
	{
		return this.m.Effects;
	}

	function getCost()
	{
		return this.m.Cost;
	}

	function getRequirements()
	{
		return this.m.Requirements;
	}

	function isValid()
	{
		return true;
	}

	function isVisible()
	{
		return true;
	}

	function isUnlocked()
	{
		for( local i = 0; i < this.m.Requirements.len(); i = ++i )
		{
			if (!this.m.Requirements[i].IsSatisfied)
			{
				return false;
			}
		}

		return true;
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 4,
				type = "description",
				text = this.getDescription()
			}
		];

		foreach( i, e in this.m.Effects )
		{
			ret.push({
				id = i,
				type = "text",
				icon = "ui/icons/special.png",
				text = e
			});
		}

		ret.push({
			id = 1,
			type = "hint",
			icon = "ui/icons/mouse_left_button.png",
			text = "Ouvrir l\'écran de recrutement pour remplacer"
		});
		return ret;
	}

	function create()
	{
	}

	function update()
	{
		this.onUpdate();
	}

	function evaluate()
	{
		for( local i = 0; i < this.m.Requirements.len(); i = ++i )
		{
			this.m.Requirements[i].IsSatisfied = false;
		}

		this.onEvaluate();
	}

	function clear()
	{
	}

	function onEvaluate()
	{
		this.m.IsUnlocked = false;
	}

	function onUpdate()
	{
	}

	function onNewDay()
	{
	}

	function onSerialize( _out )
	{
	}

	function onDeserialize( _in )
	{
	}

};

