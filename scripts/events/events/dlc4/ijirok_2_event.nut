this.ijirok_2_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.ijirok_2";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_143.png[/img]{Une tache dans les étendues enneigées attire votre attention. Avec quelques éclaireurs, vous sortez pour voir ce que c'est, ne soupçonnant rien de plus qu'une carcasse d'animal ou un camp abandonné. Au lieu de cela, vous trouvez un groupe de cadavres nus, les corps accroupis comme s'ils étaient assis sur des chaises. Ils forment un cercle étroit, sont tous tournés vers l'intérieur, certains ont les mains tendues comme s'ils se réchauffaient au feu. Vous poussez l'un des cadavres. Lorsqu'il bascule en arrière, le corps assis en face se soulève. %randombrother% saute en arrière.%SPEECH_ON%Par les anciens dieux !%SPEECH_OFF%Un rebord de chair court juste sous la neige poudreuse, et l'anneau relie un cadavre à l'autre, une profanation partagée au-delà de votre compréhension. La peau s'étend vers l'intérieur, se rejoignant sur un point d'appui charnu qui émerge de la neige en forme de pot de fleurs macabre. Il n'y a rien à l'intérieur. L'un des éclaireurs exige de retourner à la sécurité de la compagnie et vous êtes tout à fait d'accord avec lui.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Gardons ça entre nous.",
					function getResult( _event )
					{
						this.World.Flags.set("IjirokStage", 2);
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

		if (!this.World.Flags.has("IjirokStage") || this.World.Flags.get("IjirokStage") == 0 || this.World.Flags.get("IjirokStage") >= 5)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Snow || currentTile.Type != this.Const.World.TerrainType.SnowyForest)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 12)
			{
				return;
			}
		}

		this.m.Score = 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

