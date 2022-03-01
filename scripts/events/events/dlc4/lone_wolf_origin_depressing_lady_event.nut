this.lone_wolf_origin_depressing_lady_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null
	},
	function create()
	{
		this.m.ID = "event.lone_wolf_origin_depressing_lady";
		this.m.Title = "A %townname%";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_91.png[/img]{Vous croisez une vieille femme devant la maison d\'un noble. Elle vous regarde comme si elle se penchait sur son propre passé. Amusé, vous lui demandez ce qu\'elle veut. La dame sourit.%SPEECH_ON%Qu\'est-ce que vous pensez faire, exactement ? Vous errez dans le pays en tant que chevalier errant, tuant, massacrant et baisant les femmes de temps en temps ?%SPEECH_OFF%Poliment, vous l\'informez que vous n\'êtes pas un simple participant à un tournoi, mais un véritable mercenaire. Elle hausse les épaules et lance la main vers la maison d\'un noble.%SPEECH_ON%Et alors ? Ils ne vous accepteront jamais. Vous serez un combattant. Vous serez dehors, pour toujours. Vous n\'entrez que lorsqu\'ils vous laissent entrer. Ce n\'est pas un monde dans lequel vous pouvez vous améliorer. Vous êtes ce que vous êtes à votre naissance.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ce monde est ce que j\'en fais.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
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

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		this.m.Town = town;
		this.m.Score = 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
	}

});

