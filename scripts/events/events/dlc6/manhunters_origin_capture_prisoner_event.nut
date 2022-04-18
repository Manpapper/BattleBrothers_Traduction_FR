this.manhunters_origin_capture_prisoner_event <- this.inherit("scripts/events/event", {
	m = {
		LastCombatID = 0,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.manhunters_origin_capture_prisoner";
		this.m.Title = "After the battle...";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "Nobles",
			Text = "[img]gfx/ui/events/event_53.png[/img]{L\'homme survivant s\'éloigne de vous en courant. Il marmonne quelque chose. Vous ne pouvez pas l\'entendre, mais le langage est clair : il sait qui vous êtes, et ce que vous êtes. | La bataille terminée, vous trouvez un survivant dans le champ. Il est un peu écorché mais pourrait être utile. | Malgré le fait qu\'il soit le dernier homme debout, le nordiste a encore de la volonté. Il pourrait bien entrer dans la %companyname%. | Tu trouves le dernier homme debout, blessé mais vivant. C\'est un nordiste et il serait bien enchaîné. Il pourrait rapporter un bon prix dans le sud, ou servir de chair à canon sur les lignes de front ? | La troupe du nord a été abattue jusqu\'au dernier, un homme pâle qui semble ne pas s\'attarder dans la défaite. Merde du sud, ton doreur peut me sucer les couilles. Allez, donnez-moi une arme, je vais vous montrer comment meurt un nordiste!%SPEECH_OFF% On ne peut s\'empêcher d\'aimer son enthousiasme. Au lieu de servir les vers dans la tombe, peut-être pourrait-il servir la compagnie en tant qu\'endetté ?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Prenez-le comme débiteur du Doreur pour qu\'il puisse gagner son salut.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.worsenMood(2.0, "Il a perdu une bataille et a été fait prisonnier");
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "Nous n\'avons pas besoin de lui.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
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
					"slave_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "Ancien soldat fidèle aux nobles seigneurs, sa compagnie a été massacrée par vos hommes et %name% a été pris comme débiteur. Il n\'en fallait pas plus pour briser son esprit et le forcer à se battre pour vous.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Civilians",
			Text = "[img]gfx/ui/events/event_53.png[/img]{L\'homme survivant s\'éloigne de vous en courant. Il marmonne quelque chose. Vous ne pouvez pas l\'entendre, mais le langage est clair : il sait qui vous êtes, et ce que vous êtes. La bataille terminée, vous trouvez un survivant dans le champ. Il est un peu écorché, mais il pourrait vous être utile.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Prenez-le comme débiteur du Donneur pour qu\'il puisse gagner son salut.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.worsenMood(2.0, "Il a perdu une bataille et a été fait prisonnier");
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "We have no use for him.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
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
					"slave_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "%name% a été pris comme débiteur après avoir survécu de justesse à une bataille contre vos hommes. Son esprit a été brisé et il a été forcé de se battre pour vous, afin qu\'il puisse payer sa dette au Doreur.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Bandits",
			Text = "[img]gfx/ui/events/event_53.png[/img]{L\'homme survivant s\'éloigne de vous en courant. Il marmonne quelque chose. Vous ne pouvez pas l\'entendre, mais le langage est clair : il sait qui vous êtes, et ce que vous êtes. | La bataille terminée, vous trouvez un survivant dans le champ. Il est un peu écorché mais il pourrait être utile. | Le seul survivant bandit hurle pour les anciens dieux tandis que vous soupesez une chaîne dans votre main, vous demandant comment elle s\'adaptera à son cou. | Le nordique demande alors que vous pesez une chaîne dans votre main. Tu n\'es pas encore sûr de la façon dont tu vas le traiter, mais tu réponds quand même.%SPEECH_ON% Ce n\'est pas du tout une punition, c\'est simplement une question d\'affaires.%SPEECH_OFF% Le bandit essaie de se cacher, mais en tant que dernier survivant, il est aussi facile à repérer qu\'un lapin blanc sur un champ de bataille ensanglanté. Il crie que les anciens dieux ne supporteraient pas des hommes comme toi. Vous haussez les épaules. %SPEECH_ON% Les anciens dieux ne sont pas là où je suis, n\'est-ce pas ? %SPEECH_OFF% Et vous tendez la chaîne, la mesurant à son cou. %SPEECH_ON% Mais je me demande, de  quoi renoncerais-tu, pour échanger ta place avec un de tes dieux, hm ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Prenez-le comme débiteur du Doreur pour qu\'il puisse gagner son salut.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.worsenMood(2.0, "Il a perdu une bataille et a été fait prisonnier");
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "Nous n\'avons pas besoin de lui.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
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
					"slave_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "%name% a été pris comme débiteur après avoir survécu de justesse à une bataille contre vos hommes. Son esprit a été brisé et il a été forcé de se battre pour vous, afin qu\'il puisse payer sa dette au Doreur";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Nomads",
			Text = "[img]gfx/ui/events/event_172.png[/img]{L\'homme survivant s\'éloigne de vous en courant. Il marmonne quelque chose. Vous ne pouvez pas l\'entendre, mais le langage est clair : il sait qui vous êtes, et ce que vous êtes. | La bataille terminée, vous trouvez un survivant dans le champ. Il est un peu écorché mais pourrait être utile. | Vous tendez la chaîne au nomade, mesurant de loin sa tête dans le balancement de son visage fermé. Parfois, dans les sables, un homme peut rencontrer ceux avec qui il n\'aurait pas dû badiner. Parfois il s\'éloigne.%SPEECH_OFF% Tu saisis fermement la chaîne.%SPEECH_ON% Parfois il marche tout simplement.%SPEECH_OFF% | Les sables bougent et glissent alors que le nomade blessé tente de s\'échapper. Tu lui mets facilement une botte et le maintiens au sol, ton autre main mesurant son cou avec la chaîne d\'esclave. | Le nomade prie pour le pardon.%SPEECH_ON% En séparant nos ombres, l\'éclat du Doreur nous illumine tous les deux!%SPEECH_OFF% Tu lui tends une chaîne et lui dit que toutes les ombres ne naissent pas de nous.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Prenez-le comme débiteur du Doreur pour qu\'il puisse gagner son salut.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.worsenMood(2.0, "Il a perdu une bataille et a été fait prisonnier");
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "We have no use for him.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
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
					"slave_southern_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "%name% a été pris comme débiteur après avoir survécu de justesse à une bataille contre vos hommes. Son esprit a été brisé et il a été forcé de se battre pour vous, afin qu\'il puisse payer sa dette au Doreur.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "CityState",
			Text = "[img]gfx/ui/events/event_172.png[/img]{L\'homme survivant s\'éloigne de vous en courant. Il marmonne quelque chose. Vous ne pouvez pas l\'entendre, mais le langage est clair : il sait qui vous êtes, et ce que vous êtes. | La bataille terminée, vous trouvez un survivant dans le champ. Il est un peu écorché mais pourrait être utile. | C\'est le dernier de la troupe du sud, un homme blessé et pitoyable qui supplie pour sa vie. Tu tiens la chaine.%SPEECH_ON%Ce n\'est pas parce que c\'est sur toi que ton chemin est ombragé, compagnon de route. Ca veut juste dire que le mien est un peu plus lumineux.%SPEECH_OFF% | %SPEECH_ON%Ah, s\'il te plait non!%SPEECH_OFF%Tu as ta botte sur le dernier de la troupe du sud, et tu le jauge pour rejoindre les endettés. Il supplie pour sa vie, ou pour la liberté, et finalement pour mourir libre. Vous secouez la tête. L\'or ne peut ni vivre ni mourir, voyageur, il est simplement pesé. Lourd. Ou léger. Mes considérations ne vous concernent pas. Tu mendies pour quelque chose que tu as perdu au moment où tu m\'as croisé.%SPEECH_OFF% | Le dernier de la troupe du sud est à tes pieds. Il prie le doreur d\'apporter la lumière sur son chemin. Malheureusement, le seul à pouvoir s\'exprimer ici est vous-même, et vous avez une place dans les chaînes pour l\'homme si vous souhaitez qu\'il rejoigne le %companyname%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Prenez-le comme débiteur du Doreur pour qu\'il puisse gagner son salut.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.worsenMood(2.0, "Il a perdu une bataille et a été fait prisonnier");
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "We have no use for him.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
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
					"slave_southern_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "%name% a été pris comme débiteur après avoir survécu de justesse à une bataille contre vos hommes. Son esprit a été brisé et il a été forcé de se battre pour vous, afin qu\'il puisse payer sa dette au Doreur.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Barbarians",
			Text = "[img]gfx/ui/events/event_145.png[/img]{L\'homme survivant s\'éloigne de vous en courant. Il marmonne quelque chose. Vous ne pouvez pas l\'entendre, mais le langage est clair : il sait qui vous êtes, et ce que vous êtes. | La bataille terminée, vous trouvez un survivant dans le champ. Il est un peu écorché mais pourrait être utile. | Ah, le dernier survivant. C\'est un homme de grande taille, ue barbare, et il pourrait peut-être vous être utile. Enchaîné, bien sûr. |Le %companyname% a rarement rencontré des costauds tels que ces barbares du nord. Avec un dernier survivant sur le terrain, tu te demandes si le prendre comme débiteur serait à ton avantage. | Le dernier barbare debout. Il te parle dans une langue que tu n\'auras jamais le temps d\'apprendre. Il grogne, il grogne, des choses que d\'autres langues prendraient pour des menaces, mais ici vous savez qu\'il articule quelque chose d\'important. Mais, tout ce que vous avez à répondre, c\'est la chaîne, et ce barbare pourrait bien faire un très bon endetté pour le %companyname%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Prenez-le comme débiteur du Doreur pour qu\'il puisse gagner son salut.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.worsenMood(2.0, "Il a perdu une bataille et a été fait prisonnier");
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "Nous n\'avons pas besoin de lui.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
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
					"slave_barbarian_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "%name% a été pris comme débiteur après avoir survécu de justesse à une bataille contre vos hommes. Son esprit a été brisé et il a été forcé de se battre pour vous, afin qu\'il puisse payer sa dette au Doreur.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function isValid()
	{
		if (!this.Const.DLC.Desert)
		{
			return false;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.manhunters")
		{
			return;
		}

		if (this.World.Statistics.getFlags().getAsInt("LastCombatID") <= this.m.LastCombatID)
		{
			return;
		}

		if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() > 5.0 || this.World.Statistics.getFlags().getAsInt("LastCombatResult") != 1)
		{
			return false;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return false;
		}

		local f = this.World.FactionManager.getFaction(this.World.Statistics.getFlags().getAsInt("LastCombatFaction"));

		if (f == null)
		{
			return false;
		}

		if (f.getType() != this.Const.FactionType.NobleHouse && f.getType() != this.Const.FactionType.Settlement && f.getType() != this.Const.FactionType.Bandits && f.getType() != this.Const.FactionType.Barbarians && f.getType() != this.Const.FactionType.OrientalCityState && f.getType() != this.Const.FactionType.OrientalBandits)
		{
			return false;
		}

		this.m.LastCombatID = this.World.Statistics.getFlags().get("LastCombatID");
		return true;
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		local f = this.World.FactionManager.getFaction(this.World.Statistics.getFlags().getAsInt("LastCombatFaction"));

		if (f.getType() == this.Const.FactionType.NobleHouse)
		{
			return "Nobles";
		}
		else if (f.getType() == this.Const.FactionType.Settlement)
		{
			return "Civilians";
		}
		else if (f.getType() == this.Const.FactionType.Bandits)
		{
			return "Bandits";
		}
		else if (f.getType() == this.Const.FactionType.Barbarians)
		{
			return "Barbarians";
		}
		else if (f.getType() == this.Const.FactionType.OrientalCityState)
		{
			return "CityState";
		}
		else if (f.getType() == this.Const.FactionType.OrientalBandits)
		{
			return "Nomads";
		}
		else
		{
			return "Civilians";
		}
	}

	function onClear()
	{
		this.m.Dude = null;
	}

	function onSerialize( _out )
	{
		this.event.onSerialize(_out);
		_out.writeU32(this.m.LastCombatID);
	}

	function onDeserialize( _in )
	{
		this.event.onDeserialize(_in);

		if (_in.getMetaData().getVersion() >= 54)
		{
			this.m.LastCombatID = _in.readU32();
		}
	}

});

