this.lone_wolf_origin_another_squire_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.lone_wolf_origin_another_squire";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img]{%squire% s\'approche de vous en se grattant l\'arrière de la tête. On dirait qu\'il a quelque chose en tête, et vous l\'incitez à le dire. En soupirant, il demande pourquoi %squire2% a été engagé dans la compagnie.%SPEECH_ON%Il est écuyer, je suis écuyer, sommes-nous tous deux vos écuyers ?%SPEECH_OFF%Vous informez le garçon que %squire2% était l\'écuyer d\'un autre homme, mais que les choses ont changé dans sa vie pour le conduire ici. À toutes fins utiles, il est maintenant un mercenaire et %squire% est toujours votre écuyer. %squire% s\'illumine d\'un sourire, mais il se dégrade rapidement.%SPEECH_ON%Attends, ça veut dire que je suis plus mercenaire qu\'écuyer ?%SPEECH_OFF%Vous enfoncez un carnet dans la poitrine du gamin et lui dites d\'aller compter l\'inventaire.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Et dire que j\'avais l\'habitude de parcourir ces terres seul...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				_event.m.Dude.worsenMood(0.5, "Confus quant à son rôle d\'écuyer");
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.lone_wolf")
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() < 3)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local squire;
		local other_squire;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.squire")
			{
				if (bro.getFlags().get("IsLoneWolfSquire"))
				{
					squire = bro;
				}
				else
				{
					other_squire = bro;
				}
			}
		}

		if (squire == null || other_squire == null)
		{
			return;
		}

		this.m.Dude = squire;
		this.m.Other = other_squire;
		this.m.Score = 75;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"squire",
			this.m.Dude.getNameOnly()
		]);
		_vars.push([
			"squire2",
			this.m.Other.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
		this.m.Other = null;
	}

});

