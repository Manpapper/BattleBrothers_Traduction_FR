this.tailor_werewolf_hide_armor_event <- this.inherit("scripts/events/event", {
	m = {
		Tailor = null
	},
	function create()
	{
		this.m.ID = "event.tailor_werewolf_hide_armor";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]Alors que vous vous demandez où aller et quand, le tailleur %tailor% entre dans votre tente, quelque chose de sombre et de lourd enveloppant ses deux bras tendus. Vous reculez d\'un pas, voyant ce qui ressemble à des griffes ou à une manifestation de ce genre scintiller à la lumière des bougies.\n\nLe tailleur vous explique qu\'il a fabriqué une armure cousue à partir de la peau de loups-garous. Il pose l\'armure sur la table où quelques griffes restantes frappent le bois avec un poids mortel. Il déplie l\'armure et la montre dans son ensemble, une chose effroyable de noir et d\'os aiguisés, une créature privée de ses entrailles, laissée à la disposition de l\'homme ou d\'une autre créature cherchant la chaleur dans sa peau vide, la tête de la bête inclinée vers le haut pour regarder son futur porteur. Tout à fait effrayant, sans aucun doute, et vous vous demandez quand et où le tailleur a eu une telle idée en premier lieu.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Une armure redoutable à contempler.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Tailor.getImagePath());
				local stash = this.World.Assets.getStash().getItems();
				local numPelts = 0;

				foreach( i, item in stash )
				{
					if (item != null && item.getID() == "misc.werewolf_pelt")
					{
						numPelts = ++numPelts;
						stash[i] = null;
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "Vous perdez " + item.getName()
						});

						if (numPelts >= 2)
						{
							break;
						}
					}
				}

				local item = this.new("scripts/items/armor/werewolf_hide_armor");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (this.Const.DLC.Unhold)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 3 && bro.getBackground().getID() == "background.tailor")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local numPelts = 0;

		foreach( item in stash )
		{
			if (item != null && item.getID() == "misc.werewolf_pelt")
			{
				numPelts = ++numPelts;

				if (numPelts >= 2)
				{
					break;
				}
			}
		}

		if (numPelts < 2)
		{
			return;
		}

		this.m.Tailor = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = numPelts * candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"tailor",
			this.m.Tailor.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Tailor = null;
	}

});

