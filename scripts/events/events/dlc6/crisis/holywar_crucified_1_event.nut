this.holywar_crucified_1_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.crisis.holywar_crucified_1";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_161.png[/img]{Au milieu des étendues désertiques il faut se méfier de tout ce que l\'on rencontre, surtout s\'il s\'agit d\'un homme seul sur une croix. Le crucifié semble tout à fait mort, compte tenu des buses clairement perchées sur chaque épaule, mais lorsque vous vous approchez, les oiseaux s\'envolent et l\'homme relève la tête. Malgré d\'horribles blessures aux mains et aux pieds, il est plutôt vif et demande de l\'eau. Au lieu de la lui donner, vous lui demandez pourquoi il est là. L\'homme soupire.%SPEECH_ON% J\'étais un croisé. Je suis venu avec l\'armée pour gagner la gloire des anciens dieux. Mais quand je suis arrivé ici, et que j\'ai parlé avec les habitants et les prêtres, j\'ai changé d\'avis.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Les autres croisés vous ont fait ça ?",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "{[img]gfx/ui/events/event_161.png[/img]{L\'homme acquiesce. %SPEECH_ON%Oui, ils l\'ont fait. J\'étais là quand ils ont crucifié quelqu\'un d\'autre pour la même raison. Donc, en partie, je ne suis pas le gars le plus brillant pour suivre ses traces, et je n\'ai pas le cœur serein, car je les ai encouragés quand ils lui ont fait ça. Mais peut-être que le doreur verra la vraie lumière que je porte en moi, tu sais ? Il tourne la tête vers les cieux, et vers les buses qui tournent au-dessus de lui. J\'ai le Gouverneur dans mon coeur.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Vous êtes les bienvenus chez nous.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "La seule chose que tu as dans ton cœur, ce sont ces buses.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "{[img]gfx/ui/events/event_161.png[/img]{Vous sortez votre dague et libéré l\'homme. Il a de nombreuses blessures mais il est sans doute de constitution assez solide pour se remettre un jour. Il vous remercie avec une douceur remarquable compte tenu du sort qui l\'attendait.%SPEECH_ON%Content de s\'étirer. Je veux dire, vous savez, s\'étirer à mes conditions. Ouvrez la voie, capitaine de la circonstance de doreur, capitaine de sa puissante sublimité. Beaucoup dans la compagnie ne se soucient pas d\'accueillir un homme qui a tourné le dos non seulement à ses semblables, mais à ses propres dieux.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ah, il va s\'intégrer avec le reste des marginaux.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"crucified_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "Vous avez trouvé %name%, un ancien croisé du nord, crucifié au milieu du désert après avoir tourné le dos aux anciens dieux. Après l\'avoir libéré, il s\'est engagé à vous servir. Malgré ses efforts pour le cacher, il ne semble pas être dans un état mental des plus stables.";
				_event.m.Dude.getBackground().buildDescription(true);
				local trait = this.new("scripts/skills/traits/deathwish_trait");

				foreach( id in trait.m.Excluded )
				{
					_event.m.Dude.getSkills().removeByID(id);
				}

				_event.m.Dude.getSkills().add(trait);
				_event.m.Dude.setHitpointsPct(0.33);
				_event.m.Dude.improveMood(3.0, "J\'ai vu la lumière et accepté la sublimité du doreur");
				_event.m.Dude.worsenMood(3.0, "a été crucifié");
				this.Characters.push(_event.m.Dude.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getEthnicity() == 0 && this.Math.rand(1, 100) <= 66)
					{
						bro.worsenMood(1.0, "Je n\'ai pas aimé que vous empêchiez la punition légitime pour avoir trahi les anciens dieux");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "{[img]gfx/ui/events/event_161.png[/img]{vous dites à l\'homme qu\'il va bientôt parler à son ou ses dieux. Il soupire.%SPEECH_ON% D\'une certaine manière, je le mérite, mais je suis en paix avec cela.%SPEECH_OFF%Les réactions à l\'égard de la compagnie sont mitigées, et par mitigées, il s\'agit surtout de divers niveaux d\'exubérance. Après tout, cet homme est un traître à la fois à Terra et à Céleste, ce qui le rend facilement détestable par tout le monde.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ça lui sert bien.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getEthnicity() == 0 && this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(0.25, "Confiance accrue dans votre leadership");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (!this.World.FactionManager.isHolyWar())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Desert && currentTile.Type != this.Const.World.TerrainType.Oasis && currentTile.TacticalType != this.Const.World.TerrainTacticalType.DesertHills)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 5)
			{
				return;
			}
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

