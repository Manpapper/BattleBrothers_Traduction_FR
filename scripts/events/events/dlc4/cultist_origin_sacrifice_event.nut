this.cultist_origin_sacrifice_event <- this.inherit("scripts/events/event", {
	m = {
		Sacrifice = null,
		Sacrifice1 = null,
		Sacrifice2 = null,
		LastTriggeredOnDay = 0
	},
	function create()
	{
		this.m.ID = "event.cultist_origin_sacrifice";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_140.png[/img]{La plupart des gens considéreraient ce rêve comme un cauchemar : l\'obscurité vous entourait, un noir si épais que vous pourriez l\'atteindre et le toucher. La voix parlait une langue que vous n\'aviez jamais entendue auparavant, mais que vous compreniez néanmoins. Deux visages émergeaient de l\'ombre infinie : %sac1% et %sac2%. Les hommes semblaient si proches, mais lorsque vous tendiez la main, ils se s\'éloignaient, comme si vos doigts s\'étendaient à l\'infini dans le vide.\n\n À votre réveil, vous saviez ce qui devait être fait. Mais Davkul vous a accordé sa confiance. Une confiance pour faire ce que peu d\'hommes peuvent faire : faire un choix. | La présence de Davkul s\'est fait sentir pendant un feu de camp. Le reste des hommes s\'est fondu dans l\'éther du noir infini, et une étrange entité les a remplacés. Une entité que vous ne pouviez pas voir, mais dont la présence n\'était qu\'une pénombre traversée d\'ombres. Elle a demandé un sacrifice, non pas en vous parlant, mais en vous montrant : %sac1% et %sac2%. L\'un d\'eux a d\'abord fondu avant de se revivifier, puis l\'autre a répété le processus jusqu\'à ce que tous deux existent avec les mains tendues et les yeux fermés. Il était clair que Davkul vous laissait le choix. \n\n Quand les ombres se sont dissipées, le feu de camp était éblouissant. %sac1% et %sac2% vous regardaient fixement.%SPEECH_ON%Tout va bien, monsieur ?%SPEECH_OFF% | You traveled to the place. Vous saviez que vous dormiez, mais vous saviez pertinemment que vous vous y rendiez néanmoins, vous déplaçant au-delà de votre esprit, au-delà de votre corps, courant sur la terre, sur ses rivières, sur sa terre sèche, et au-delà des montagnes qui s\'effondreraient. Là, vous avez trouvé Davkul, l\'obscurité immuable, l\'ombre invitante.\n\n %sac1% et %sac2% étaient déjà là, se tenant au plus près de toi et la forme de Davkul se déplaçait sans cesse derrière leurs images. Une main noir de brouillard a poussé un homme en avant puis l\'a tiré en arrière, puis a répété l\'opération avec l\'autre homme. Vous avez hoché la tête en signe de compréhension. Un sacrifice était nécessaire et vous deviez choisir.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "%sac1% aura l\'honneur de rencontrer Davkul.",
					function getResult( _event )
					{
						_event.m.Sacrifice = _event.m.Sacrifice1;
						return "B";
					}

				},
				{
					Text = "%sac2% aura l\'honneur de rencontrer Davkul.",
					function getResult( _event )
					{
						_event.m.Sacrifice = _event.m.Sacrifice2;
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Sacrifice1.getImagePath());
				this.Characters.push(_event.m.Sacrifice2.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_140.png[/img]{Le %sacrifice% est lié et mis au feu. L\'odeur de porc brûlé emplit l\'air et les hommes qui vous entourent se réjouissent, les larmes aux yeux. Vous voyez un visage se tordre dans la fumée du sacrifice, un visage complice qui approuve. Les hommes sont enhardis. | %sacrifice% est découpé en morceaux jusqu\'à ce qu\'il ne reste qu\'un torse et une tête. Le sang s\'est répandu sur le sol, mais il y a encore de la lumière dans ses yeux et un sourire pervers sur son visage. Vous prenez un manche de hache et l\'enfoncez dans sa gorge jusqu\'à ce qu\'il ne soit plus. Chaque partie du corps est séparée et mise sur un poteau, recouverte de graisse, et enflammée. Vous et les hommes dansez sous les bûchers alors que la nuit vient et que la nuit passe. | La procédure est la suivante : Le %sacrifice% est écorché vif et transpercé de bâtons aiguisés à travers chaque membre et maintenu en l\'air, les jambes écartées, au-dessus d\'un feu qui le cuit jusqu\'à la mort. Les hommes assistent à son décès en silence, mais dès qu\'un de ses membres carbonisés se brise et que son cadavre s\'effondre dans les flammes, les hommes applaudissent et hurlent, certains prient, d\'autres se roulent dans les cendres de %sacrifice%, certains les lèchent du bout des doigts comme si c\'était des bonbons. C\'est une bonne nuit. | Un long bâton est enfoncé dans %sacrifice% de son postérieure à la latérale de son cou. Il est incliné vers le ciel et maintenu là par un homme tandis que d\'autres utilisent de longues lances pour le transpercer jusqu\'à ce que son cadavre soit le sommet d\'une tente découverte. Le cadavre conique est alors recouvert d\'herbe et de boue jusqu\'à ce qu\'il reste que le torse et la tête de %sacrifice%, et si vous entrez dans la tente, vous trouverez ses jambes qui pendent de son plafond. Le monument doit être un présage pour ceux qui viendront, et un signe qu\'ils doivent accepter de ce qui nous attend tous.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Un rappel pour nous tous.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Sacrifice.getImagePath());
				local dead = _event.m.Sacrifice;
				local fallen = {
					Name = dead.getName(),
					Time = this.World.getTime().Days,
					TimeWithCompany = this.Math.max(1, dead.getDaysWithCompany()),
					Kills = dead.getLifetimeStats().Kills,
					Battles = dead.getLifetimeStats().Battles,
					KilledBy = "Sacrificed to Davkul",
					Expendable = dead.getBackground().getID() == "background.slave"
				};
				this.World.Statistics.addFallen(fallen);
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Sacrifice.getName() + " est mort"
				});
				_event.m.Sacrifice.getItems().transferToStash(this.World.Assets.getStash());
				this.World.getPlayerRoster().remove(_event.m.Sacrifice);
				local brothers = this.World.getPlayerRoster().getAll();
				local hasProphet = false;

				foreach( bro in brothers )
				{
					if (bro.getSkills().hasSkill("trait.cultist_prophet"))
					{
						hasProphet = true;
						break;
					}
				}

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
					{
						bro.improveMood(2.0, "Appeased Davkul");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}

						for( ; this.Math.rand(1, 100) > 50;  )
						{
						}

						local skills = bro.getSkills();
						local skill;

						if (skills.hasSkill("trait.cultist_prophet"))
						{
							continue;
						}
						else if (skills.hasSkill("trait.cultist_chosen"))
						{
							if (hasProphet)
							{
								continue;
							}

							hasProphet = true;
							this.updateAchievement("VoiceOfDavkul", 1, 1);
							skills.removeByID("trait.cultist_chosen");
							skill = this.new("scripts/skills/actives/voice_of_davkul_skill");
							skills.add(skill);
							skill = this.new("scripts/skills/traits/cultist_prophet_trait");
							skills.add(skill);
						}
						else if (skills.hasSkill("trait.cultist_disciple"))
						{
							skills.removeByID("trait.cultist_disciple");
							skill = this.new("scripts/skills/traits/cultist_chosen_trait");
							skills.add(skill);
						}
						else if (skills.hasSkill("trait.cultist_acolyte"))
						{
							skills.removeByID("trait.cultist_acolyte");
							skill = this.new("scripts/skills/traits/cultist_disciple_trait");
							skills.add(skill);
						}
						else if (skills.hasSkill("trait.cultist_zealot"))
						{
							skills.removeByID("trait.cultist_zealot");
							skill = this.new("scripts/skills/traits/cultist_acolyte_trait");
							skills.add(skill);
						}
						else if (skills.hasSkill("trait.cultist_fanatic"))
						{
							skills.removeByID("trait.cultist_fanatic");
							skill = this.new("scripts/skills/traits/cultist_zealot_trait");
							skills.add(skill);
						}
						else
						{
							skill = this.new("scripts/skills/traits/cultist_fanatic_trait");
							skills.add(skill);
						}

						if (skill != null)
						{
							this.List.push({
								id = 10,
								icon = skill.getIcon(),
								text = bro.getName() + " est maintenant " + this.Const.Strings.getArticle(skill.getName()) + skill.getName()
							});
						}
					}
					else if (!bro.getSkills().hasSkill("trait.mad"))
					{
						bro.worsenMood(4.0, "Horrifié par le sacrifice de " + _event.m.Sacrifice.getName());

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
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.getTime().Days <= 5)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.cultists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 4)
		{
			return;
		}

		brothers.sort(function ( _a, _b )
		{
			if (_a.getXP() < _b.getXP())
			{
				return -1;
			}
			else if (_a.getXP() > _b.getXP())
			{
				return 1;
			}

			return 0;
		});
		local r = this.Math.rand(0, this.Math.min(2, brothers.len() - 1));
		this.m.Sacrifice1 = brothers[r];
		brothers.remove(r);
		r = this.Math.rand(0, this.Math.min(2, brothers.len() - 1));
		this.m.Sacrifice2 = brothers[r];
		this.m.Score = 50 + (this.World.getTime().Days - this.m.LastTriggeredOnDay);
	}

	function onPrepare()
	{
		this.m.LastTriggeredOnDay = this.World.getTime().Days;
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"sac1",
			this.m.Sacrifice1.getName()
		]);
		_vars.push([
			"sac2",
			this.m.Sacrifice2.getName()
		]);
		_vars.push([
			"sacrifice",
			this.m.Sacrifice != null ? this.m.Sacrifice.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Sacrifice1 = null;
		this.m.Sacrifice2 = null;
		this.m.Sacrifice = null;
	}

	function onSerialize( _out )
	{
		this.event.onSerialize(_out);
		_out.writeU16(this.m.LastTriggeredOnDay);
	}

	function onDeserialize( _in )
	{
		this.event.onDeserialize(_in);

		if (_in.getMetaData().getVersion() >= 62)
		{
			this.m.LastTriggeredOnDay = _in.readU16();
		}
	}

});

