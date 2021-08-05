this.glutton_gets_fat_event <- this.inherit("scripts/events/event", {
	m = {
		Glutton = null
	},
	function create()
	{
		this.m.ID = "event.glutton_gets_fat";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_14.png[/img] Vous trouvez %glutton% en train de se servir une troisième portion de nourriture. C\'est beaucoup trop et vous exigez que ce soit la dernière. Un autre frère d\'arme se joint à vous, se moquant de l\'homme pour ses habitudes. Le glouton, enragé, fait claquer sa nourriture et se lève. Son estomac, cependant, se balance à un rythme différent de celui du reste de son corps et l\'homme plutôt gras s\'écroule dans un tas de membres agités. Alors que le reste de la compagnie rit, on ne peut s\'empêcher de se demander si le mercenaire n\'est pas devenu trop gros.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Lâchez ce porc. Maintenant.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Glutton.getImagePath());
				local trait = this.new("scripts/skills/traits/fat_trait");
				_event.m.Glutton.getSkills().add(trait);
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.Glutton.getName() + " devient gros"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getFood() < 100)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 3 && bro.getSkills().hasSkill("trait.gluttonous") && !bro.getSkills().hasSkill("trait.fat"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Glutton = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"glutton",
			this.m.Glutton.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Glutton = null;
	}

});

