this.cultist_origin_armor_event <- this.inherit("scripts/events/event", {
	m = {
		Tailor = null
	},
	function create()
	{
		this.m.ID = "event.cultist_origin_armor";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 15.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_03.png[/img]{Une urgence prend %randomcultist%. Il se lève, s\'éloigne de la fête du feu de camp, traverse à grands pas le terrain de camping et se retire dans sa tente. C\'est là qu\'on le voit à l\'oeuvre, sa silhouette et ses ombres bougeant frénétiquement. Et il n\'y a pas que lui là-dedans : des courbes inconnues vont et viennent à ses côtés, s\'élevant en perches de noir, en vrilles de ténèbres, fouettant et s\'agitant à la mesure de l\'énergie de sa propre procession. Et puis il a fini, sa silhouette tombe en avant avant de faire apparaître quelque chose dans la lumière.\n\nIl sort de sa tente avec la même hâte qu\'il y est entré, mais cette fois, il a une pièce d\'armure de poitrine en cuir à la main. Il la laisse tomber sur le sol.%SPEECH_ON%Il nous attend tous, mes frères.%SPEECH_OFF%L\'armure du torse est ornée de découpes uniques disposées en bandes qui, pour un œil incrédule, n\'ont aucun sens. Pour vous, ce n\'est qu\'un langage de Davkul.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Davkul attend.",
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

				foreach( i, item in stash )
				{
					if (item != null && (item.getID() == "armor.body.padded_leather" || item.getID() == "armor.body.padded_surcoat" || item.getID() == "armor.body.rugged_surcoat" || item.getID() == "armor.body.thick_tunic" || item.getID() == "armor.body.blotched_gambeson"))
					{
						stash[i] = null;
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "Vous perdez " + item.getName()
						});
						break;
					}
				}

				local item = this.new("scripts/items/armor/cultist_leather_robe");
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
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.cultists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local numItems = 0;

		foreach( item in stash )
		{
			if (item != null && (item.getID() == "armor.body.padded_leather" || item.getID() == "armor.body.padded_surcoat" || item.getID() == "armor.body.rugged_surcoat" || item.getID() == "armor.body.thick_tunic" || item.getID() == "armor.body.blotched_gambeson"))
			{
				numItems = ++numItems;
			}
		}

		if (numItems == 0)
		{
			return;
		}

		this.m.Tailor = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = numItems * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"randomcultist",
			this.m.Tailor.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Tailor = null;
	}

});

