this.undead_crusader_leaves_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.crisis.undead_crusader_leaves";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_35.png[/img]%crusader% le croisé s\'approche de vous sans son armure, son casque dans le creux de son coude.%SPEECH_ON%Monsieur, je dois dire adieu à la compagnie. Avec les morts-vivants battus, ma mission est terminée.%SPEECH_OFF%Vous allez serrer la main de l\'homme, mais il vous tend simplement son casque et son arme.%SPEECH_ON%Vous en avez plus besoin que moi. Mes combats d\'aujourd\'hui sont finis. Ce fut un plaisir de chevaucher au crépuscule avec toi à mes côtés. Envoyez mes salutations aux hommes.%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Adieu !",
					function getResult( _event )
					{
						_event.m.Dude.getItems().transferToStash(this.World.Assets.getStash());
						this.World.getPlayerRoster().remove(_event.m.Dude);
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Dude.getName() + " quitte " + this.World.Assets.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.FactionManager.isUndeadScourge())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() == 1)
		{
			return;
		}

		local crusader;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.crusader")
			{
				crusader = bro;
				break;
			}
		}

		if (crusader == null)
		{
			return;
		}

		this.m.Dude = crusader;
		this.m.Score = 100;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"crusader",
			this.m.Dude.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

